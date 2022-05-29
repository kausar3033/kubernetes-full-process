### Step 1: Install helm 3 in our workstation		
		
		cd ~/
		curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
		chmod 700 get_helm.sh
		./get_helm.sh
		
		helm version		
		
### Step 2: Deploy Nginx Ingress Controller		

		controller_tag=$(curl -s https://api.github.com/repos/kubernetes/ingress-nginx/releases/latest | grep tag_name | cut -d '"' -f 4)
		wget https://github.com/kubernetes/ingress-nginx/archive/refs/tags/${controller_tag}.tar.gz		
		
### Extract the file downloaded:		

		tar xvf ${controller_tag}.tar.gz		
		
### Switch to the directory created:		

		cd ingress-nginx-${controller_tag}		
		
### Change your working directory to charts folder:
		
		cd charts/ingress-nginx/		
		
### List nodes:	

		kubectl get nodes		
		
### Update values.yml file to change parameters:		
		
		vim values.yaml		

### Add tolerations for Master nodes
		
		controller:
		  tolerations:
			- key: node-role.kubernetes.io/master
			  operator: Equal
			  value: ""true""
			  effect: NoSchedule
			- key: node-role.kubernetes.io/master
			  operator: Equal
			  effect: NoSchedule		
		
### Setcontroller.service.externalIPs		
		controller:
		  service:
			externalIPs: [""192.168.42.245"",""192.168.42.246""]		
		
### To set number of replicas of the Ingress controller deployment on		
		controller:
		  replicaCount: 1		
		
### If using node selector for pod assignment for the Ingress controller pods set on	

		 controller:
		  nodeSelector:
			kubernetes.io/os: linux
			runingress: ""nginx""		
		
### Create namespace if needed
		
		kubectl create namespace ingress-nginx		
		
### Now deploy Nginx Ingress Controller using the following commands
		
##### helm install -n ingress-nginx ingress-nginx  -f values.yaml .

		helm repo add nginx-stable https://helm.nginx.com/stable
		helm install ibosio-ingress nginx-stable/nginx-ingress --set controller.service.type=LoadBalancer

### If want to create multiple ingress use this comman with new ingress name

		helm install ibosio-ingress nginx-stable/nginx-ingress --set controller.service.type=LoadBalancer,controller.ingressClass=ibosio-ingress

### If want to add ssl/tls 

		kubectl  create secret tls ibosio-ingress-tls --key private_key.pem --cert cert.pem

		
### Check status of all resources iningress-nginx namespace:

		kubectl get all -n ingress-nginx		
		
### Pods

		kubectl get pods -n ingress-nginx		

