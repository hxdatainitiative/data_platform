#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#Cambio de password por motivos de seguridad
sudo docker exec -it sqlserverdb /opt/mssql-tools/bin/sqlcmd \
-S localhost -U SA \
 -P syJwY6sHsu \
 -Q "ALTER LOGIN SA WITH PASSWORD=\"$(read -sp "Ingrese su contraseña para SQL con 8 o + caracts, números y alguna mayusc: "; echo "${REPLY}")\""
