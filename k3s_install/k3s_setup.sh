# TODO: multithreading while adding agents
# read_cfg cfgA &
# read_cfg cfgB &
# read_cfg cfgC &
# wait

# server 1
k3sup install --k3s-version v1.19.1-rc2+k3s1 \
    --cluster \
    --user root \
    --ip 10.0.0.35 \
    --k3s-extra-args '--docker --write-kubeconfig-mode 644 --no-deploy=traefik --node-taint k3s-controlplane=true:NoExecute' \
    --datastore="mysql://root:TietoEVRY2021*@tcp(10.0.0.70:3306)/kubernetes" \
    --tls-san 10.0.0.60

# server 2
k3sup install --k3s-version v1.19.1-rc2+k3s1 \
      --ip 10.0.0.40 \
      --host-ip 10.0.0.35 \
      --user root \
      --k3s-extra-args '--docker --no-deploy=traefik --node-taint k3s-controlplane=true:NoExecute' \
      --datastore="mysql://root:TietoEVRY2021*@tcp(10.0.0.70:3306)/kubernetes" \
      --tls-san 10.0.0.60

# join agent node1
k3sup join \
    --ip 10.0.0.50 \
    --user root \
    --server-ip 10.0.0.35 \
    --k3s-extra-args '--docker'

# join agent node2
k3sup join \
    --ip 10.0.0.51 \
    --user root \
    --server-ip 10.0.0.35 \
    --k3s-extra-args '--docker'

# join agent node3
k3sup join \
    --ip 10.0.0.52 \
    --user root \
    --server-ip 10.0.0.35 \
    --k3s-extra-args '--docker'

# join agent node4
k3sup join \
    --ip 10.0.0.53 \
    --user root \
    --server-ip 10.0.0.35 \
    --k3s-extra-args '--docker'