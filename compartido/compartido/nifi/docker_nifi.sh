#!/bin/bash
# -*- ENCODING: UTF-8 -*-
sudo docker-compose up --scale nifi=3 -d
sudo docker-compose start 

exit
