## Install Nginx 
	apt-get install nginx 
	
### Create namespace if needed
	kubectl create namespace staging		
		
### Now deploy Nginx Ingress Controller service using the following commands

#### If want to add in specific namespace (staging)
	helm -n staging install ibosio-ingress nginx-stable/nginx-ingress --set controller.service.type=LoadBalancer,controller.ingressClass=ibosio-ingress

### Check status of all resources iningress-nginx namespace:
	kubectl -n staging get all 	
	
	kubectl get svc
		
### Pods
	kubectl get pods

## Example for add multiple class
## [ Start Example
#### Default controller service 
	helm install ibosio-ingress nginx-stable/nginx-ingress --set controller.service.type=LoadBalancer
	
### If want to create multiple ingress use this comman with new ingress name
	helm install ibosio-ingress nginx-stable/nginx-ingress --set controller.service.type=LoadBalancer,controller.ingressClass=ibosio-ingress
	
## End Example ]

