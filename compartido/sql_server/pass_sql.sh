#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#Cambio de password por motivos de seguridad
sudo docker exec -it sqlserverdb /opt/mssql-tools/bin/sqlcmd -c " \
-S localhost -U SA \ ;
-P "$(read -sp "Enter current SA password: "; echo "${REPLY}")" \ ;
-Q "ALTER LOGIN SA WITH PASSWORD=\"$(read -sp "Enter new SA password: "; echo "${REPLY}")\"" "

exit
