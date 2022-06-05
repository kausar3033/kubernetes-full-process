## Welcome to Kubernetes Full deployment 

<p> Kubernetes is an open-source container orchestration system for automating software deployment, scaling, and management. Google originally designed Kubernetes, but the Cloud Native Computing 
Foundation now maintains the project </p>

## First Step:

### *How to install kubernetes master node 

### *How to install kubernetes worker node 

### *How to install MetalLLB for Loadbnlancing 

### *How to install Helm

### *Install kubernetes Nginx Ingress Controller using Helm 

## second Step 

### *How to create secret

### *How to create ingress rules and execute it



# Create Secret
### If want to add ssl/tls 
#### upload cert.pem and private_key.pem file in your /home/user directory then execute the command 
	kubectl  create secret tls ibosio-ingress-tls --key private_key.pem --cert cert.pem

# Create ingress rules and execute 
#### Create a yaml file like ibos_ingress.yaml and write configuration rules and save it
    kubectl -n staging apply -f ibos_ingress.yaml
