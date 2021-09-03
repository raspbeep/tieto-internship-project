# ON PROXMOX PVE-01

# install master
k3sup install --k3s-version v1.19.1-rc2+k3s1 \
    --cluster \
    --user root \
    --ip 10.0.0.35 \
    --k3s-extra-args '--docker --no-deploy=traefik' \
    --datastore="mysql://root:TietoEVRY2021*@tcp(10.0.0.70:3306)/kubernetes"

# install server
k3sup install --k3s-version v1.19.1-rc2+k3s1 \
      --ip 10.0.0.40 \
      --server-ip 10.0.0.35 \
      --user root \
      --server \
      --k3s-extra-args '--docker --no-deploy=traefik' \
      --datastore="mysql://root:TietoEVRY2021*@tcp(10.0.0.70:3306)/kubernetes"
      
# args that we might use
#--k3s-extra-args '--docker --no-deploy=traefik --bind-address=ip 10.0.0.35 --advertise-address=ip 10.0.0.35 --node-ip= 10.0.0.35 --node-external-ip 172.31.0.204'

# join agent node1
k3sup join \
    --ip 10.0.0.50 \
    --user root \
    --server-ip 10.0.0.35 \
    --k3s-extra-args '--docker' \

# join agent node2
k3sup join \
    --ip 10.0.0.51 \
    --user root \
    --server-ip 10.0.0.35 \
    --k3s-extra-args '--docker' \

# join agent node3
k3sup join \
    --ip 10.0.0.52 \
    --user root \
    --server-ip 10.0.0.35 \
    --k3s-extra-args '--docker' \

# join agent node4
k3sup join \
    --ip 10.0.0.53 \
    --user root \
    --server-ip 10.0.0.35 \
    --k3s-extra-args '--docker' \

# connect to database
Heslo na db:    TietoEVRY2021*
show databases;
drop database kubernetes;

# install kubectl on pve-01
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# before new shell connect
export KUBECONFIG=/root/kubeconfig

# uninstall script po neuspesnej instalacii serveru
/usr/local/bin/k3s-uninstall.sh

# uninstall script po neuspesnej instalacii agentu
/usr/local/bin/k3s-agent-uninstall.sh


