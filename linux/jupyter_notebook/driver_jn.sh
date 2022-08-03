#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#Instalación del driver para conexión con SQL Server
sudo docker exec -it -u 0 jupyter_notebook_1 /bin/bash -c "apt-get install python;apt-get --assume-yes update;apt-get --assume-yes install freetds-dev freetds-bin;apt-get --assume-yes install python-dev python3-pip;pip install pyodbc;pip install pymssql"
exit
