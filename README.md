## Welcome to Kubernetes Full deployment 

<p> Kubernetes is an open-source container orchestration system for automating software deployment, scaling, and management. Google originally designed Kubernetes, but the Cloud Native Computing 
Foundation now maintains the project </p>

## First Step:

### *How to install kubernetes master node 

### *How to install kubernetes worker node 

### *How to install MetalLLB for Loadbnlancing 

### *How to install Helm

### *Install kubernetes Nginx Ingress Controller using Helm 

## Second Step 

### *How to create secret

### *How to create ingress rules and execute it



# Create Secret
### If want to add ssl/tls 
#### upload cert.pem and private_key.pem file in your /home/user directory then execute the command 
	kubectl  create secret tls ibosio-ingress-tls --key private_key.pem --cert cert.pem

# Create ingress rules and execute 
#### Create a yaml file like ibos_ingress.yaml and write configuration rules and save it
    kubectl -n staging apply -f ibos_ingress.yaml
    
## Basic Command 
	helm version
	helm list
	helm -n staging  list
	helm -n staging  repo list
	helm -n staging  repo update
	
	kubectl get node
	kubectl get all 
	kubectl get pods -n ingress-nginx	
	kubectl get namespaces
	kubectl get ns
	
	kubectl -n staging get pod
	kubectl -n staging get ingressclass -o wide
	kubectl -n staging get ingressclass
	kubectl -n staging describe pod
	kubectl -n staging get configmap
	kubectl -n metallb-system describe configmap config
	kubectl -n metallb-system get  configmap config -o yaml
	kubectl -n metallb-system describe configmap config
	kubectl -n staging get svc
	kubectl -n staging get all
	kubectl get pods --all-namespaces
	kubectl get pods --namespace staging
	
