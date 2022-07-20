#!/bin/bash
# -*- ENCODING: UTF-8 -*-

sudo docker build -t superset_orig . 
sudo docker run -d -p 8080:8088 --name superset superset_orig

sudo docker exec -it superset superset fab create-admin \
              --username admin \
              --firstname Superset \
              --lastname Admin \
              --email admin@superset.com \
              --password admin
 
sudo docker exec -it superset superset db upgrade
sudo docker exec -it superset superset load_examples
sudo docker exec -it superset superset init
exit
