#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#Instalación de Great Expectations
sudo docker exec -it -u 0 jupyter_notebook_1 /bin/bash -c "python -m pip install great_expectations"
exit