db_ip=10.0.0.70
db_name=kubernetes
db_pass=TietoEVRY2021*

mysql -h $db_ip -u root -p$db_pass $db_name < "db_setup.sql"

ssh $db_ip "systemctl start mysql && systemctl enable mysql && systemctl restart mysql"
