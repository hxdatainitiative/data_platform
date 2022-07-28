read -p"Ingrese nombre de usuario para Nifi: " USER_ACC
read -p"Ingrese una contraseña para Nifi: " USER_PAS
echo $USER_ACC
echo $USER_PAS
export USER_ACCESS=$(echo $USER_ACC)
export USER_PASS=$(echo $USER_PAS)
export IP_ADRESS=$(ip -o -4 addr list eth0 |awk '{print $4}' |cut -d / -f1)
destdir=./.env
echo "USER_ACCESS="$USER_ACCESS"" >> "$destdir"
echo "USER_PASS="$USER_PASS"" >> "$destdir"
echo "IP_AD="$IP_ADRESS"" >> "$destdir"
