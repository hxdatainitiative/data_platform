REM Creacion de red segura de comunicacion entre los contenedores por network
docker network create my-net-sql

REM Despliegue de nifi en docker
set directory=%~dp0
cd %directory%
cd ./nifi

REM definimos las variables
set /p USER_ACCESS= "Ingrese nombre de usuario para Nifi: " 
set /p USER_PASS= "Ingrese una password para Nifi: "
echo USER_ACCESS=%USER_ACCESS%> .env
echo USER_PASS=%USER_PASS%>> .env
for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set NetworkIP=%%a
echo NetworkIP=%NetworkIP%>> .env

REM Inicializamos nifi
docker-compose up -d
cd ..

REM Despliegue de Superset en Docker
cd ./superset

REM inicializamos Superset
docker build -t superset_orig . 
docker run -d -p 8080:8088 --name superset superset_orig

docker exec -it superset superset fab create-admin
 
docker exec -it superset superset db upgrade
docker exec -it superset superset load_examples
docker exec -it superset superset init

docker exec -it -u 0 superset /bin/bash -c "curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - ; curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list ; apt-get update ; ACCEPT_EULA=Y apt-get install -y msodbcsql18 ; apt-get install -y python;apt-get --assume-yes update;apt-get --assume-yes install freetds-dev freetds-bin;apt-get --assume-yes install python-dev python3-pip;pip install pyodbc;pip install pymssql"
cd ..

REM Despliegue de Jupyter Notebook en Docker
cd ./jupyter_notebook
docker-compose up -d
docker exec -it -u 0 jupyter_notebook_1 /bin/bash -c "apt-get install python;apt-get --assume-yes update;apt-get --assume-yes install freetds-dev freetds-bin;apt-get --assume-yes install python-dev python3-pip;pip install pyodbc;pip install pymssql"
cd ..

REM Despliegue de SQL Server en Docker
cd ./sql_server
set /p PASS_SQL= "Ingrese su contrasena para SQL con 8 o + caracts, numeros y alguna mayusc: "
echo PASS_SQL=%PASS_SQL%> .env
docker pull mcr.microsoft.com/mssql/server:2022-latest
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=%PASS_SQL%" ^
   -p 1433:1433 --name sqlserverdb --hostname sqlserverdb ^
   -d ^
   mcr.microsoft.com/mssql/server:2022-latest
cd ..

REM Instalación del driver para conexion con SQL Server
docker cp ./mssql-jdbc-8.4.1.jre8.jar nifi:/mssql-jdbc-8.4.1.jre8.jar

REM Conexión entre los contenedores por network
docker network connect my-net-sql jupyter_notebook_1
docker network connect my-net-sql superset
docker network connect my-net-sql sqlserverdb

REM Instalacion de Conda y MLFlow
cd ./mlflow
docker cp ./database.sh superset:/app/database.sh
docker cp ./mlflow-tracking.service superset:/etc/systemd/system/mlflow-tracking.service
docker exec -it -u 0 superset /bin/bash -c " cd .. ; apt-get install -y libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6; wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh; bash Anaconda3-2022.05-Linux-x86_64.sh -b -u; export PATH="~/anaconda3/bin:$PATH" >> ~/.bashrc; source ~/.bashrc"
docker exec -it -u 0 superset /bin/bash -c "cd .. ; export PATH="~/anaconda3/bin:$PATH"; apt-get update -y; source ~/.bashrc; conda init fish; conda update conda -y; conda create -n mlflow_env -y; conda activate mlflow_env; conda install -y python ; pip install mlflow; apt-get install -y postgresql postgresql-contrib postgresql-server-dev-all ; pg_ctlcluster 13 main start; service postgresql restart"
docker exec -it -u postgres superset /bin/bash -c "./database.sh"
docker exec -it -u 0 superset /bin/bash -c "apt install -y gcc; pip install -y  psycopg2; mkdir ~/mlruns; mlflow server --backend-store-uri postgresql://mlflow:mlflow@localhost/mlflow --default-artifact-root file:/home/your_user/mlruns -h 0.0.0.0 -p 8000 -d; cd /etc/systemd/system; apt-get install systemctl; systemctl daemon-reload; systemctl enable mlflow-tracking; systemctl start mlflow-tracking; echo 'export MLFLOW_TRACKING_URI='http://0.0.0.0:8000'' >> ~/.bashrc; . ~/.bashrc"
pause