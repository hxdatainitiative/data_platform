#### Es requisito tener instalado docker antes de correr el dataplatform.bat, por favor primero corra docker_install.bat y aseguresé que docker quede abierto.


# Despliegue Windows

## docker_install.bat
### Instalacion de Docker
```
curl -s -L -o DockerDesktopInstaller.exe "https://desktop.docker.com/win/main/amd64/Docker%%20Desktop%%20Installer.exe" 
start /WAIT "" "DockerDesktopInstaller.exe" install --quiet --accept-license --backend=windows
cd C:\Program Files\Docker\Docker
START "" "Docker Desktop.exe"
### Espere a que se abra Docker Desktop y termine de startear (Podra ver el mensaje: Run a Sample Container), luego presione una tecla para continuar
pause
```

### Hacemos un switch a los contenedores de linux  
```
DockerCli.exe -SwitchLinuxEngine
### Espere a que se abra nuevamente Docker Desktop y termine de startear, luego presione una tecla para continuar
pause
```

## dataplatform.bat

### Creación de red segura de comunicación entre los contenedores por network
```
sudo docker network create my-net-sql
```

### Despliegue de NiFi en Docker
```
set directory=%~dp0 
cd %directory% 
cd ./nifi 
```

#### Definimos las variables
```
set /p USER_ACCESS= "Ingrese nombre de usuario para Nifi: "  
set /p USER_PASS= "Ingrese una password para Nifi: " 
echo USER_ACCESS=%USER_ACCESS%> .env 
echo USER_PASS=%USER_PASS%>> .env 
for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set NetworkIP=%%a 
echo NetworkIP=%NetworkIP%>> .env 
```

#### Inicializamos nifi 
```
docker-compose up -d 
cd .. 
```

### Despliegue de Superset en Docker 
```
cd ./superset
```
#### inicializamos Superset 
```
docker build -t superset_orig .  
docker run -d -p 8080:8088 --name superset superset_orig
docker exec -it superset superset fab create-admin
docker exec -it superset superset db upgrade
docker exec -it superset superset load_examples
docker exec -it superset superset init
docker exec -it -u 0 superset /bin/bash -c "curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - ; curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list ; apt-get update ; ACCEPT_EULA=Y apt-get install -y msodbcsql18 ; apt-get install -y python;apt-get --assume-yes update;apt-get --assume-yes install freetds-dev freetds-bin;apt-get --assume-yes install python-dev python3-pip;pip install pyodbc;pip install pymssql" 
cd .. 
```

### Despliegue de Jupyter Notebook en Docker 
```
cd ./jupyter_notebook 
docker-compose up -d 
docker exec -it -u 0 jupyter_notebook_1 /bin/bash -c "apt-get install python;apt-get --assume-yes update;apt-get --assume-yes install freetds-dev freetds-bin;apt-get --assume-yes install python-dev python3-pip;pip install pyodbc;pip install pymssql" 
cd ..  
```

### Despliegue de SQL Server en Docker 
```
cd ./sql_server 
set /p PASS_SQL= "Ingrese su contrasena para SQL con 8 o + caracts, numeros y alguna mayusc: " 
echo PASS_SQL=%PASS_SQL%> .env 
docker pull mcr.microsoft.com/mssql/server:2022-latest 
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=%PASS_SQL%" ^ 
   -p 1433:1433 --name sql1 --hostname sql1 ^ 
   -d ^ 
   mcr.microsoft.com/mssql/server:2022-latest 
cd .. 
```

#### Instalación del driver para conexion con SQL Server 
```
docker cp ./mssql-jdbc-8.4.1.jre8.jar nifi:/mssql-jdbc-8.4.1.jre8.jar 
```

### Conexión entre los contenedores por network 
```
docker network connect my-net-sql jupyter_notebook_1 
docker network connect my-net-sql superset 
docker network connect my-net-sql sqlserverdb 
pause 
cmd
```


## Utilización de la plataforma
Para utilizar cada una de las aplicaciones deberá hacerlo desde el browser, ingresando IP:Puerto ; Por ej: localhost:8080
Con el comando "docker ps" podrá ver el puerto que tiene asignado cada uno de los contenedores. 

Sin embargo le dejamos detallado como ingresar a cada uno de ellos:

#### Nifi
https://localhost:8443/nifi/

#### Superset
localhost:8080

#### Jupyter Notebook
localhost:8888

#### SQL Server
Si quiere conectar alguno de los otros contenedores al contenedor de SQL Server podrá hacerlo mediante un string de conexión de SQL Alchemy, solo deberá buscar cuál es el ip que tiene asignado el contenedor de SQL Server para la conexión creada (my-net-sql)

Para esto debe correr el comando: docker network inspect my-net-sql

Luego buscar la "IPAddress" asignada al contenedor "sqlserverdb", esa ingresará en el siguiente string. El string sería:
mssql+pymssql://usuarioSQL:contraseñaSQL@IPAddress/database

##### Instalación de SSMS
En caso de querer instalar SQL Server Management Studio, esta le permitirá administrar el motor de base de datos y escribir código de Transact-SQL, visite el siguiente link:
https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16

Link de descarga:
https://aka.ms/ssmsfullsetup
