## Install Nginx (optional)
	apt-get install nginx 
	
### Check Namespace 
	kubectl get ns
	
### Create namespace if needed
	kubectl create namespace staging
	
	kubectl run nginx --image=nginx --namespace=staging
	kubectl config set-context --current --namespace=staging
		
### Now deploy Nginx Ingress Controller service using the following commands

#### If want to add in specific namespace (staging)
	helm -n staging install ibosio-ingress nginx-stable/nginx-ingress --set controller.service.type=LoadBalancer,controller.ingressClass=ibosio-ingress

## if not working 
 helm -n staging install ibosio-ingress-new nginx-stable/nginx-ingress \
 --set controller.service.type=LoadBalancer \
 --set controller.ingressClass.name=ibosio-ingress \
 --set controller.ingressClass.create=true \
 --set controller.ingressClass.setAsDefaultIngress=false

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

