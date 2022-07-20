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

