sudo docker exec -it -u 0 superset /bin/bash -c "apt install -y gcc;
pip install -y  psycopg2;
mkdir ~/mlruns;
mlflow server --backend-store-uri postgresql://mlflow:mlflow@localhost/mlflow --default-artifact-root file:/home/your_user/mlruns -h 0.0.0.0 -p 8000 -d;

##Production
cd /etc/systemd/system ;/
echo '[Unit]
Description=MLflow tracking server
After=network.target

[Service]
Restart=on-failure
RestartSec=30
ExecStart=/bin/bash -c 'PATH=~/anaconda3/envs/mlflow_env/bin/:$PATH exec mlflow server --backend-store-uri postgresql://mlflow:mlflow@localhost/mlflow --default-artifact-root file:/home/your_user/mlruns -h 0.0.0.0 -p 8000'

[Install]
WantedBy=multi-user.target' > mlflow-tracking.service;/

apt-get install systemctl;/
systemctl daemon-reload;/
systemctl enable mlflow-tracking;/
systemctl start mlflow-tracking;/
echo 'export MLFLOW_TRACKING_URI='http://0.0.0.0:8000'' >> ~/.bashrc;/
. ~/.bashrc
"
exit
