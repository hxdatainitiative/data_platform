REM Instalacion de Docker
curl -s -L -o DockerDesktopInstaller.exe "https://desktop.docker.com/win/main/amd64/Docker%%20Desktop%%20Installer.exe" 
start /WAIT "" "DockerDesktopInstaller.exe" install --quiet --accept-license --backend=windows

cd C:\Program Files\Docker\Docker
START "" "Docker Desktop.exe"
REM Espere a que se abra Docker Desktop y termine de startear (Podra ver el mensaje: Run a Sample Container), luego presione una tecla para continuar
pause

REM Hacemos un switch a los contenedores de linux  
DockerCli.exe -SwitchLinuxEngine
REM Espere a que se abra nuevamente Docker Desktop y termine de startear, luego presione una tecla para continuar
pause