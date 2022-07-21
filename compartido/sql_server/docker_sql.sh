#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#Creación el contenedor
sudo docker pull mcr.microsoft.com/mssql/server:2022-latest
sudo docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=syJwY6sHsu" \
	   --name sqlserverdb --hostname sqlserverdb \
	      -d \
	         mcr.microsoft.com/mssql/server:2022-latest
exit
