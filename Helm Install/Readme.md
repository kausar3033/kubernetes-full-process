
#### Install Helm 

		curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -

		sudo apt-get install apt-transport-https --yes

		echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

		sudo apt-get update

		sudo apt-get install helm
		
#### Check Helm
Check the helm list (you will see a output like image)
		helm list
		
		
<img width="475" alt="image" src="https://user-images.githubusercontent.com/50922314/172037458-37c6e7af-16e8-4817-92c4-e8a21dd4ed83.png">


##### now you need to add the helm repo and chart and Update by using the comand 
		
		helm -n staging repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
		
		helm -n staging repo add  stable https://charts.helm.sh/stable
		
		helm repo add nginx-stable https://helm.nginx.com/stable
		
		helm -n staging  repo update
		
#### you will see a output Happy Helming


#### Now check the repo lis by using the comand

		helm -n staging  repo list
		
