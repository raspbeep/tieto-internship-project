# TODO: ssh-keygen -f "/root/.ssh/known_hosts" -R "10.0.0.60"

bal_ip=10.0.0.60
# # TODO: args=-o "StrictHostKeyChecking no"

# update and upgrade
ssh $args $bal_ip "apt-get -y update && apt-get -y upgrade"

# apt install mysql-server instance
ssh $args $bal_ip "apt-get install nginx -y"

# stop nginx service before config change
ssh $args $bal_ip "systemctl stop nginx"

# remove old config file
ssh $args $bal_ip "rm -f /etc/nginx/nginx.conf"

# provide a new config file
scp ./nginx.conf $bal_ip:/etc/nginx/nginx.conf

# enable nginx service by deafault
ssh $args $bal_ip "systemctl enable nginx"

# start nginx service
ssh $args $bal_ip "systemctl start nginx"