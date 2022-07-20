#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#Creación el contenedor
sudo docker pull mcr.microsoft.com/mssql/server:2022-latest
sudo docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Hxdataplatform2022!" \
   --name sqlserverdb --hostname sqlserverdb \
   -d \
   mcr.microsoft.com/mssql/server:2022-latest
exit
