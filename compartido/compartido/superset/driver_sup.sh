#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#Instalación del driver para la conexión con SQL Server
sudo docker exec -it -u 0 superset /bin/bash -c 'curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - ; curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list ; apt-get update ; ACCEPT_EULA=Y apt-get install -y msodbcsql18 ; apt-get install -y python;apt-get --assume-yes update;apt-get --assume-yes install freetds-dev freetds-bin;apt-get --assume-yes install python-dev python3-pip;pip install pyodbc;pip install pymssql'
exit

