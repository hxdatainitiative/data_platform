sudo docker exec -it -u 0 superset /bin/bash -c "
cd .. ;/
apt-get install -y libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6;/
wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh;/
bash Anaconda3-2022.05-Linux-x86_64.sh -b;/
export PATH="~/anaconda3/bin:$PATH" >> ~/.bashrc;/
source ~/.bashrc;
"


exit
