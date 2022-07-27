# Despliegue .sh usado


## dataplatform.sh
### Instalación de Docker

sudo apt update

sudo apt install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - -y

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

sudo apt update

sudo apt install docker-ce -y

### Creación de red segura de comunicación entre los contenedores por network

sudo docker network create my-net-sql

### Instalación docker-compose

sudo apt install docker-compose -y


## Despliegue de NiFi en Docker
cd ./nifi 

./variables.sh

./docker_nifi.sh 

cd ..


## Despliegue de Superset en Docker
cd ./superset 

./superset.sh 

./driver_sup.sh 

cd .. 

## Despliegue de Jupyter Notebook en Docker
cd ./jupyter_notebook 

./docker_jn.sh 

./driver_jn.sh 

cd .. 


## Despliegue de SQL Server en Docker
cd ./sql_server 

./docker_sql.sh 

./pass_sql.sh

cd .. 

### Instalación del driver para conexión con SQL Server
sudo docker cp ./mssql-jdbc-8.4.1.jre8.jar nifi:/mssql-jdbc-8.4.1.jre8.jar 

## Conexión entre los contenedores por network
sudo docker network connect my-net-sql jupyter_notebook_1

sudo docker network connect my-net-sql superset

sudo docker network connect my-net-sql sqlserverdb

exit


# docker_nifi.sh
sudo docker-compose up -d

exit

## variables.sh
read -p"Ingrese nombre de usuario para Nifi: " USER_ACC

read -p"Ingrese una contraseña para Nifi: " USER_PAS

echo $USER_ACC

echo $USER_PAS

export USER_ACCESS=$(echo $USER_ACC)

export USER_PASS=$(echo $USER_PAS)

destdir=./.env

echo "USER_ACCESS="$USER_ACCESS"" >> "$destdir"

echo "USER_PASS="$USER_PASS"" >> "$destdir"



# superset.sh
sudo docker build -t superset_orig .

sudo docker run -d -p 8080:8088 --name superset superset_orig

sudo docker exec -it superset superset fab create-admin

sudo docker exec -it superset superset db upgrade

sudo docker exec -it superset superset load_examples

sudo docker exec -it superset superset init

exit


# driver_sup.sh
### Instalación del driver para la conexión con SQL Server
sudo docker exec -it -u 0 superset /bin/bash -c 'curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - ; curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list ; apt-get update ; ACCEPT_EULA=Y apt-get install -y msodbcsql18 ; apt-get install –y python;apt-get --assume-yes update;apt-get --assume-yes install freetds-dev freetds-bin;apt-get --assume-yes install python-dev python3-pip;pip install pyodbc;pip install pymssql' 

exit


# docker_jn.sh
sudo docker-compose up -d

exit


## driver_jn.sh:
### Instalación del driver para conexión con SQL Server
sudo docker exec -it -u 0 jupyter_notebook_1 /bin/bash -c "apt-get install python;apt-get --assume-yes update;apt-get --assume-yes install freetds-dev freetds-bin;apt-get --assume-yes install python-dev python3-pip;pip install pyodbc;pip install pymssql" 

exit


# docker_sql.sh
### Creación el contenedor

sudo docker pull mcr.microsoft.com/mssql/server:2022-latest

sudo docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$(read -sp "Ingrese su contraseña para SQL con 8 o + caracts, números y alguna mayusc: "; echo "${REPLY}")" \

--name sqlserverdb --hostname sqlserverdb \

-d \

mcr.microsoft.com/mssql/server:2022-latest

exit

