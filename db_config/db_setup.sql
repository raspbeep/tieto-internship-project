-- create database kubernetes
CREATE DATABASE kubernetes;
-- create root user to be able to connect from arbitrary IP
CREATE USER 'root'@'%' IDENTIFIED BY 'TietoEVRY2021*';
-- grant all privileges to root to kubernetes db
GRANT ALL PRIVILEGES ON kubernetes.* TO 'root'@'%';
-- change password for root connected from localhost
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'TietoEVRY2021*';


-- Implementation of mysql_secure_install
-- delete anonymous user
DELETE FROM mysql.user WHERE User='';
-- set new privileges
FLUSH PRIVILEGES;