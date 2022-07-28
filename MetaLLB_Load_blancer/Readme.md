# K8s_Installing_MetalLB_Load_Balancer
## About Load Balancers
#### Load balancers can be used for exposing applications to the external network. Load balancer provides a single IP address to route incoming requests to your app. In order to successfully create Kubernetes services of type LoadBalancer, you need to have the load balancer (implementation) available for Kubernetes.

## Install MetalLB
    
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml

    
    
## Create ConfigMap for MetalLB

#### Create a YAML file accordingly, and deploy it: 

    
    apiVersion: v1
    kind: ConfigMap
    metadata:
      namespace: metallb-system
      name: config
    data:
      config: |
        address-pools:
        - name: default
          protocol: layer2
          addresses:
          - <ip-address-range-start>-<ip-address-range-stop>
          
## Execute 
    kubectl apply -f metallb-configmap.yaml
          
 ## You can assing single ip or can assign ip range
 
 # K8s_Installing_MetalLB_Load_Balancer
## About Load Balancers
#### Load balancers can be used for exposing applications to the external network. Load balancer provides a single IP address to route incoming requests to your app. In order to successfully create Kubernetes services of type LoadBalancer, you need to have the load balancer (implementation) available for Kubernetes.

## Install MetalLB
    
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml

    
    
## Create ConfigMap for MetalLB

#### Create a YAML file accordingly, and deploy it: 

    
    apiVersion: v1
    kind: ConfigMap
    metadata:
      namespace: metallb-system
      name: config
    data:
      config: |
        address-pools:
        - name: default
          protocol: layer2
          addresses:
          - <ip-address-range-start>-<ip-address-range-stop>
          
## Execute 
    kubectl apply -f metallb-configmap.yaml
          
 ## You can assing single ip or can assign ip range
 
 ## If the external ip is pending us the comand 
    kubectl patch svc ibosio-ingress-nginx-ingress -n staging -p '{"spec": {"type": "LoadBalancer", "externalIPs":["pending-ip"]}}'
