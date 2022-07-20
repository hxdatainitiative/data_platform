#!/bin/bash
# -*- ENCODING: UTF-8 -*-
import pyodbc
print("conexión:")
#Add your own SQL Server IP address, PORT, UID, PWD and Database
conn = pyodbc.connect(
    'DRIVER={FreeTDS};SERVER=HXNB-FLAHITTETT\SQLEXPRESS;DATABASE=ProyectoFinal', autocommit=True)
cur = conn.cursor()
print('conexión completa')
cur.close()
conn.close()
