#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#Creación el contenedor
sudo docker pull mcr.microsoft.com/mssql/server:2022-latest
sudo docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$(read -sp "Ingrese su contraseña para SQL con 8 o + caracts, números y alguna mayusc: "; echo "${REPLY}")" \
   --name sqlserverdb --hostname sqlserverdb \
   -d \
   mcr.microsoft.com/mssql/server:2022-latest
exit
