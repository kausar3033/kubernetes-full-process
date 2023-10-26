
# Troubleshooting

#### If the node status in showiing not-ready just enable the docker and turn of the the swap memory of all-nodes

    sudo systemctl enable docker.service
    sudo swapoff -a
    
    
### If Delete Node from master

    kubectl delete node <node-name>
    
####https://stackoverflow.com/questions/35757620/how-to-gracefully-remove-a-node-from-kubernetes
    
### If we want  remove existing worker node connection from master node and want to add the worker node to new master node ,lets see...

    cd /etc/kubernetes/ 
    ls
    rm kubelet.conf
    rm pki -r
    fuser 10251/tcp
    kubeadm reset

### Now you can join the worker node to new master node.

### If the external ip is pending use the comand [pending -ip]

      kubectl patch svc ibosio-ingress-nginx-ingress -n staging -p '{"spec": {"type": "LoadBalancer", "externalIPs":["1.10.1.10"]}}'  
      
  kubectl patch svc ibosio-ingress-nginx-ingress -n staging -p '{"spec": {"type": "LoadBalancer", "externalIPs":["1.10.1.10"]}}'  
### If the external ip is pending use the comand [pending -ip]
  helm -n staging install ibosio-ingress nginx-stable/nginx-ingress --set controller.service.type=LoadBalancer,controller.ingressClass.name=ibosio-ingress,controller.ingressClass.create=true,controller.ingressClass.setAsDefaultIngress=false,controller.service.loadBalancerIP=10.209.99.107
### If the external ip is pending use the comand [pending -ip]
  helm -n staging uninstall ibosio-ingress

  
### Happy Kubernetes!!!
      
