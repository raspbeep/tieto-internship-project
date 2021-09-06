kubectl apply -f ./testdeployment.yml

# should be visible in kubernetes dashboard by now

# testing with curl commmand against localhost
kubectl exec nginx-deployment-7db4866645-bcpnf -- curl localhost

# scaling the number of pods
kubectl scale --replicas=28 deploy/nginx-deployment

# delete the entire deployment
kubectl delete deploy nginx-deployment
