#!/bin/bash
# -*- ENCODING: UTF-8 -*-
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
cd ./nifi
./variables.sh
./docker_nifi.sh
cd ..

#Despliegue de Superset en Docker
cd ./superset
./superset.sh
./driver_sup.sh
cd ..

#Despliegue de Jupyter Notebook en Docker
cd ./jupyter_notebook
./docker_jn.sh
./driver_jn.sh
cd ..

#Despliegue de SQL Server en Docker
cd ./sql_server
./variables_sql.sh
./docker_sql.sh
cd ..

#Instalación del driver para conexión con SQL Server
sudo docker cp ./mssql-jdbc-8.4.1.jre8.jar nifi:/mssql-jdbc-8.4.1.jre8.jar

#Conexión entre los contenedores por network
sudo docker network connect my-net-sql jupyter_notebook_1
sudo docker network connect my-net-sql superset
sudo docker network connect my-net-sql sqlserverdb

exit

