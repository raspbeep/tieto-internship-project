#!/bin/bash

# update and upgrade. Maybe not necessary?
apt-get update && apt-get upgrade

apt-get install mysql-server -y

# TODO: implement this
# https://bertvv.github.io/notes-to-self/2015/11/16/automating-mysql_secure_installation/
sudo mysql_secure_installation
# TODO: add settings in the mysql_secure_installation

# change this using sed?
vim /etc/mysql/mysql.conf.d/mysqld.cnf
bindadress 127.0.0.1  ----> 0.0.0.0

# connect to a database on localhost
sudo mysql -u root -p

# create a database
CREATE DATABASE kubernetes;

# https://stackoverflow.com/questions/50177216/how-to-grant-all-privileges-to-root-user-in-mysql-8-0/50197630

# create a new user with specific privileges to connect from whatever ip address
CREATE USER 'root'@'%' IDENTIFIED BY 'TietoEVRY2021*';
GRANT ALL PRIVILEGES ON kubernetes.* TO 'root'@'%';

# restrict root@localhost to connect w/o a password
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'TietoEVRY2021*';

FLUSH PRIVILEGES;

# restart mysql server
sudo systemctl start mysql
sudo systemctl enable mysql
sudo systemctl restart mysql

# ON PROXMOX PVE-01

k3sup install \
    --ip 10.0.0.35 \
    --user root \
    --cluster \
    --k3s-extra-args '--docker' \
    --datastore="mysql://root:TietoEVRY2021*@tcp(10.0.0.70:3306)/kubernetes"

k3sup join \
    --ip 10.0.0.40 \
    --user root \
    --server-user root \
    --server-ip 10.0.0.35 \
    --server \
    --k3s-extra-args '--docker' \
    --datastore="mysql://root:TietoEVRY2021*@tcp(10.0.0.70:3306)/kubernetes"

# uninstall script po neuspesnej instalacii
/usr/local/bin/k3s-uninstall.sh

Heslo na db:    TietoEVRY2021*
show databases;
drop database kubernetes;



