# Despliegue en Linux

## dataplatform.sh

#### Instalación de Docker
```
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
sudo apt install docker-ce -y
```
#### Creación de red segura de comunicación entre los contenedores por network
```
sudo docker network create my-net-sql
```
#### Instalación docker-compose
```
sudo apt install docker-compose -y
```
#### Despliegue de NiFi en Docker
```
cd ./nifi 
./variables.sh
./docker_nifi.sh 
cd ..
```

#### Despliegue de Superset en Docker
```
cd ./superset 
./superset.sh 
./driver_sup.sh 
cd .. 
```

#### Despliegue de Jupyter Notebook en Docker
```
cd ./jupyter_notebook 
./docker_jn.sh 
./driver_jn.sh 
cd .. 
```

#### Despliegue de SQL Server en Docker
```
cd ./sql_server 
./docker_sql.sh 
./pass_sql.sh
cd ..
``` 

#### Instalación del driver para conexión con SQL Server
```
sudo docker cp ./mssql-jdbc-8.4.1.jre8.jar nifi:/mssql-jdbc-8.4.1.jre8.jar 
```

#### Conexión entre los contenedores por network
```
sudo docker network connect my-net-sql jupyter_notebook_1
sudo docker network connect my-net-sql superset
sudo docker network connect my-net-sql sqlserverdb
exit
```

### docker_nifi.sh
```
sudo docker-compose up -d
exit
```

### variables.sh
```
read -p"Ingrese nombre de usuario para Nifi: " USER_ACC
read -p"Ingrese una contraseña para Nifi: " USER_PAS
echo $USER_ACC
echo $USER_PAS
export USER_ACCESS=$(echo $USER_ACC)
export USER_PASS=$(echo $USER_PAS)
destdir=./.env
echo "USER_ACCESS="$USER_ACCESS"" >> "$destdir"
echo "USER_PASS="$USER_PASS"" >> "$destdir"
```

### superset.sh
```
sudo docker build -t superset_orig .
sudo docker run -d -p 8080:8088 --name superset superset_orig
sudo docker exec -it superset superset fab create-admin
sudo docker exec -it superset superset db upgrade
sudo docker exec -it superset superset load_examples
sudo docker exec -it superset superset init
exit
```

### driver_sup.sh
#### Instalación del driver para la conexión con SQL Server
```
sudo docker exec -it -u 0 superset /bin/bash -c 'curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - ; curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list ; apt-get update ; ACCEPT_EULA=Y apt-get install -y msodbcsql18 ; apt-get install –y python;apt-get --assume-yes update;apt-get --assume-yes install freetds-dev freetds-bin;apt-get --assume-yes install python-dev python3-pip;pip install pyodbc;pip install pymssql' 
exit
```

### docker_jn.sh
```
sudo docker-compose up -d
exit
```

### driver_jn.sh:
#### Instalación del driver para conexión con Jupyter Notebook
```
sudo docker exec -it -u 0 jupyter_notebook_1 /bin/bash -c "apt-get install python;apt-get --assume-yes update;apt-get --assume-yes install freetds-dev freetds-bin;apt-get --assume-yes install python-dev python3-pip;pip install pyodbc;pip install pymssql" 
exit
```

### docker_sql.sh
#### Creación del contenedor
```
sudo docker pull mcr.microsoft.com/mssql/server:2022-latest
sudo docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$(read -sp "Ingrese su contraseña para SQL con 8 o + caracts, números y alguna mayusc: "; echo "${REPLY}")" \
--name sqlserverdb --hostname sqlserverdb \
-d \
mcr.microsoft.com/mssql/server:2022-latest
exit
```

## Utilización de la plataforma
Para utilizar cada una de las aplicaciones deberá hacerlo desde el browser, ingresando IP:Puerto ; Por ej: localhost:8080
Con el comando "docker ps" podrá ver el puerto que tiene asignado cada uno de los contenedores. 

<<<<<<< HEAD:README.md
# MLflow
## anaconda.sh 
### Instalación de Anaconda
```
sudo docker exec -it -u 0 superset /bin/bash -c " 
cd .. ;/ 
apt-get install -y libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6;/ 
wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh;/ 
bash Anaconda3-2022.05-Linux-x86_64.sh -b;/ 
export PATH="~/anaconda3/bin:$PATH" >> ~/.bashrc;/ 
source ~/.bashrc; 
" 
exit
```

## database.sh
### Creación de archivo para ejecución de los comandos SQL
```
createuser -e mlflow -s 
psql -U postgres -c "CREATE DATABASE mlflow;" 
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE mlflow TO mlflow;" 
exit 
```

## mlflow.sh
```
sudo docker exec -it -u 0 superset /bin/bash -c " 
cd .. ;/ 
export PATH="~/anaconda3/bin:$PATH";/ 
apt-get update -y;/ 
conda init fish;/ 
conda update conda -y;/ 
conda create -n mlflow_env -y;/ 
###Instalación de MLflow 
conda activate mlflow_env;/ 
conda install -y python ;/ 
pip install mlflow;/ 
##Instalacion de PostgreSQL 
apt-get install -y postgresql postgresql-contrib postgresql-server-dev-all ;/ 
pg_ctlcluster 13 main start;/ 
service postgresql restart;/" 

exit 
```

## mlflow2.sh
```
sudo docker exec -it -u 0 superset /bin/bash -c "apt install -y gcc; 
pip install -y  psycopg2; 
mkdir root/mlruns; 
mlflow server --backend-store-uri postgresql://mlflow:mlflow@localhost/mlflow --default-artifact-root file:/home/your_user/mlruns -h 0.0.0.0 -p 8000 -d; 
###Production 
cd /etc/systemd/system ;/ 
echo '[Unit] 
Description=MLflow tracking server 
After=network.target 
[Service] 
Restart=on-failure 
RestartSec=30 
ExecStart=/bin/bash -c 'PATH=root/anaconda3/envs/mlflow_env/bin/:$PATH exec mlflow server --backend-store-uri postgresql://mlflow:mlflow@localhost/mlflow --default-artifact-root file:/home/your_user/mlruns -h 0.0.0.0 -p 8000' 
[Install] 
WantedBy=multi-user.target' > mlflow-tracking.service;/ 
apt-get install systemctl;/ 
systemctl daemon-reload;/ 
systemctl enable mlflow-tracking;/ 
systemctl start mlflow-tracking;/ 
echo 'export MLFLOW_TRACKING_URI='http://0.0.0.0:8000'' >> ~/.bashrc;/ 
. ~/.bashrc 
" 

exit 
```

## sqlcom.sh
```
sudo docker exec -it -u postgres superset /bin/bash -c "./database.sh;" 
exit 
```
=======

Sin embargo le dejamos detallado como ingresar a cada uno de ellos:

#### Nifi
https://localhost:8443/nifi/

#### Superset
localhost:8080

#### Jupyter Notebook
localhost:8888

#### SQL Server
Si quiere conectar alguno de los otros contenedores al contenedor de SQL Server podrá hacerlo mediante un string de conexión de SQL Alchemy, solo deberá buscar cuál es el ip que tiene asignado el contenedor de SQL Server para la conexión creada (my-net-sql)

Para esto debe correr el comando: docker network inspect my-net-sql

Luego buscar la "IPAddress" asignada al contenedor "sqlserverdb", esa ingresará en el siguiente string. El string sería:
mssql+pymssql://usuarioSQL:contraseñaSQL@IPAddress/database
