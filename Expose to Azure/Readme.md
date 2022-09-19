### kubernates secret token to join with Azure (add the trusted key )

    kubectl config view --raw

## For expose to azure with public ip

    rm /etc/kubernetes/pki/apiserver.*
    kubeadm init phase certs all --apiserver-advertise-address=0.0.0.0 --apiserver-cert-extra-sans=Master-IP,public-IP
    docker rm `docker ps -q -f 'name=k8s_kube-apiserver*'`
  
  ### Create docker registry in master 
  
    kubectl -n staging create secret docker-registry dockercred --docker-server=https://index.docker.io --docker-username=dockerhub_username --docker-password=1234 --docker-email=test@test-gmail.com
