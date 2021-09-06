db_ip=10.0.0.70
db_name=kubernetes

ssh-keygen -f "/root/.ssh/known_hosts" -R "${db_ip}"

# update and upgrade
ssh $db_ip "apt-get -y update && apt-get -y upgrade"

# apt install mysql-server instance
ssh $db_ip "apt-get install mysql-server -y"

# change the bind-address
ssh $db_ip "sed -i '0,/127.0.0.1/s//0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf"

# before new shell connect
#export KUBECONFIG=/root/kubeconfig
scp ./db_setup.sql $db_ip:~/

ssh $db_ip "mysql < ./db_setup.sql"

ssh $db_ip "systemctl start mysql && systemctl enable mysql && systemctl restart mysql"