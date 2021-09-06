# copy kubeconfig to ~/.kube/config

# get all information about a namespace
# kubectl -n kubernetes-dashboard get all

sudo k3s kubectl create -f dashboard.admin-user.yml -f dashboard.admin-user-role.yml

sudo k3s kubectl -n kubernetes-dashboard describe secret admin-user-token | grep '^token'

sudo k3s kubectl proxy

#use token

# On desktop VM
kubectl -n kubernetes-dashboard port-forward <name of dashboard pod> 8000:8443

# OR

# Node Port method
# 7:00 https://www.youtube.com/watch?v=6MnsSvChl1E
#type: NodePort
#nodePort: 32333

# accessible on nodeIP:nodePort

# Delete the dashboard

