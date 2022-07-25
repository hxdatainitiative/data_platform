<<<<<<< HEAD
                                       Despliegue .sh usado


dataplatform.sh:

#Instalación de Docker
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - -y
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
sudo apt install docker-ce -y

#Creación de red segura de comunicación entre los contenedores por network
sudo docker network create my-net-sql

#Instalación docker-compose
sudo apt install docker-compose -y

#despliegue de nifi en docker
cd /home/compartido/nifi
./docker_nifi.sh

#Despliegue de Superset en Docker
cd /home/compartido/superset
./superset.sh
./driver_sup.sh

#Despliegue de Jupyter Notebook en Docker
cd /home/compartido/jupyter_notebook
./docker_jn.sh
./driver_jn.sh
#Despliegue de SQL Server en Docker
cd /home/compartido/sql_server
./docker_sql.sh
./pass_sql.sh

#Instalación del driver para conexión con SQL Server
sudo docker cp /home/compartido/mssql-jdbc-8.4.1.jre8.jar nifi_nifi_1:/mssql-jdbc-8.4.1.jre8.jar
sudo docker cp /home/compartido/mssql-jdbc-8.4.1.jre8.jar nifi_nifi_2:/mssql-jdbc-8.4.1.jre8.jar
sudo docker cp /home/compartido/mssql-jdbc-8.4.1.jre8.jar nifi_nifi_3:/mssql-jdbc-8.4.1.jre8.jar
sudo docker cp /home/compartido/mssql-jdbc-8.4.1.jre8.jar zookeeper:/mssql-jdbc-8.4.1.jre8.jar

#Conexión entre los contenedores por network
sudo docker network connect my-net-sql jupyter_notebook_1
sudo docker network connect my-net-sql superset
sudo docker network connect my-net-sql sqlserverdb

exit


docker_nifi.sh:
sudo docker-compose up --scale nifi=3 -d
sudo docker-compose start

exit


superset.sh:
sudo docker build -t superset_orig .
sudo docker run -d -p 8080:8088 --name superset superset_orig

sudo docker exec -it superset superset fab create-admin \
              --username admin \
              --firstname Superset \
              --lastname Admin \
              --email admin@superset.com \
              --password admin

sudo docker exec -it superset superset db upgrade
sudo docker exec -it superset superset load_examples
sudo docker exec -it superset superset init
exit


driver_sup.sh:
#Instalación del driver para la conexión con SQL Server
sudo docker exec -it -u 0 superset /bin/bash -c 'curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - ; curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list ; apt-get update ; ACCEPT_EULA=Y apt-get install -y msodbcsql18'
exit


docker_jn.sh:
sudo docker-compose up -d
exit


driver_jn.sh:
#Instalación del driver para conexión con SQL Server
sudo docker exec -it -u 0 jupyter_notebook_1 /bin/bash -c "apt-get install python;apt-get --assume-yes update;apt-get --assume-yes install freetds-dev freetds-bin;apt-get --assume-yes install python-dev python3-pip;pip install pyodbc;pip install pymssql"
exit


docker_sql.sh:
#Creación el contenedor
sudo docker pull mcr.microsoft.com/mssql/server:2022-latest
sudo docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Hxdataplatform2022!" \
--name sqlserverdb --hostname sqlserverdb \
-d \
mcr.microsoft.com/mssql/server:2022-latest
exit


pass_sql.sh:
#Cambio de password por motivos de seguridad
sudo docker exec -it sqlserverdb /opt/mssql-tools/bin/sqlcmd -c " \
-S localhost -U SA \ ;
-P "$(read -sp "Enter current SA password: "; echo "${REPLY}")" \ ;
-Q "ALTER LOGIN SA WITH PASSWORD=\"$(read -sp "Enter new SA password: "; echo "${REPLY}")\"" "

exit
=======
# data_platform
Contains the Hx Data Platform for single click deploys
'You can read information about the project here'
>>>>>>> origin

