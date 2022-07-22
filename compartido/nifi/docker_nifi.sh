#!/bin/bash
# -*- ENCODING: UTF-8 -*-

read -p"Ingrese nombre de usuario" USER_ACC
read -p"Ingrese una contraseña" USER_PAS
export USER_ACCESS=$(echo $USER_ACC)
export USER_PASS=$(echo $USER_PAS)


docker run --name nifi \
  -p 8443:8443 \
  -d \
  -e SINGLE_USER_CREDENTIALS_USERNAME=${USER_ACCESS} \
  -e SINGLE_USER_CREDENTIALS_PASSWORD=${USER_PASS} \
  apache/nifi:latest
exit
