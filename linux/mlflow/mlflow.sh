sudo docker exec -it -u 0 superset /bin/bash -c "
cd .. ;/
export PATH="~/anaconda3/bin:$PATH";/
apt-get update -y;/
conda init fish;/
conda update conda -y;/
conda create -n mlflow_env -y;/

#Instalación de MLflow
conda activate mlflow_env;/
conda install -y python ;/
pip install mlflow;/
##Instalacion de PostgreSQL
apt-get install -y postgresql postgresql-contrib postgresql-server-dev-all ;/
pg_ctlcluster 13 main start;/
service postgresql restart;/"
exit
