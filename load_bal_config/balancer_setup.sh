bal_ip=10.0.0.60

# update and upgrade
ssh $args $bal_ip "apt-get -y update && apt-get -y upgrade"

# apt install mysql-server instance
ssh $args $bal_ip "apt-get install nginx -y"

# stop nginx service before config change
ssh $args $bal_ip "systemctl stop nginx"


#Original contents retained as /root/.ssh/known_hosts.old
#Warning: Permanently added '10.0.0.60' (ECDSA) to the list of known hosts.
#Hit:1 http://archive.ubuntu.com/ubuntu hirsute InRelease
#Hit:2 http://archive.ubuntu.com/ubuntu hirsute-updates InRelease
#Hit:3 http://archive.ubuntu.com/ubuntu hirsute-backports InRelease
#Hit:4 https://download.docker.com/linux/ubuntu focal InRelease
#Hit:5 http://security.ubuntu.com/ubuntu hirsute-security InRelease
#Reading package lists...
#E: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 1664 (apt-get)
#E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?
#E: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 1664 (apt-get)
#E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?
#Failed to stop nginx.service: Unit nginx.service not loaded.
#scp: /etc/nginx/nginx.conf: No such file or directory
#Failed to enable unit: Unit file nginx.service does not exist.
#Failed to start nginx.service: Unit nginx.service not found.
#make: *** [Makefile:18: loadbal] Error 5

# remove old config file
ssh $args $bal_ip "rm -f /etc/nginx/nginx.conf"

# provide a new config file
scp ./nginx.conf $bal_ip:/etc/nginx/nginx.conf

# enable nginx service by deafault
ssh $args $bal_ip "systemctl enable nginx"

# start nginx service
ssh $args $bal_ip "systemctl start nginx"