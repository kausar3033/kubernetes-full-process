#!/bin/sh -x
set -x


kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml
cat <<EOL >> metallb-configmap.yaml
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
      - 10.209.99.107-10.209.99.108
EOL

chmod +x metallb-configmap.yaml
kubectl apply -f metallb-configmap.yaml

curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
helm -n staging repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm -n staging repo add  stable https://charts.helm.sh/stable
helm repo add nginx-stable https://helm.nginx.com/stable
helm -n staging  repo update
helm -n staging  repo list

kubectl get ns
kubectl create namespace staging
kubectl run nginx --image=nginx --namespace=staging
kubectl config set-context --current --namespace=staging
helm -n staging install ibosio-ingress nginx-stable/nginx-ingress --set controller.service.type=LoadBalancer,controller.ingressClass=ibosio-ingress --set controller.service.loadBalancerIP="10.209.99.107"
#helm -n staging install ibosio-ingress nginx-stable/nginx-ingress --set controller.service.type=LoadBalancer,controller.ingressClass=ibosio-ingress
kubectl -n staging get all 	
kubectl get svc


cat <<EOL >> cert.pem
-----BEGIN CERTIFICATE-----
MIIGEzCCA/ugAwIBAgIQfVtRJrR2uhHbdBYLvFMNpzANBgkqhkiG9w0BAQwFADCB
iDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0pl
cnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNV
BAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTgx
MTAyMDAwMDAwWhcNMzAxMjMxMjM1OTU5WjCBjzELMAkGA1UEBhMCR0IxGzAZBgNV
BAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYGA1UE
ChMPU2VjdGlnbyBMaW1pdGVkMTcwNQYDVQQDEy5TZWN0aWdvIFJTQSBEb21haW4g
VmFsaWRhdGlvbiBTZWN1cmUgU2VydmVyIENBMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEA1nMz1tc8INAA0hdFuNY+B6I/x0HuMjDJsGz99J/LEpgPLT+N
TQEMgg8Xf2Iu6bhIefsWg06t1zIlk7cHv7lQP6lMw0Aq6Tn/2YHKHxYyQdqAJrkj
eocgHuP/IJo8lURvh3UGkEC0MpMWCRAIIz7S3YcPb11RFGoKacVPAXJpz9OTTG0E
oKMbgn6xmrntxZ7FN3ifmgg0+1YuWMQJDgZkW7w33PGfKGioVrCSo1yfu4iYCBsk
Haswha6vsC6eep3BwEIc4gLw6uBK0u+QDrTBQBbwb4VCSmT3pDCg/r8uoydajotY
uK3DGReEY+1vVv2Dy2A0xHS+5p3b4eTlygxfFQIDAQABo4IBbjCCAWowHwYDVR0j
BBgwFoAUU3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFI2MXsRUrYrhd+mb
+ZsF4bgBjWHhMA4GA1UdDwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0G
A1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAbBgNVHSAEFDASMAYGBFUdIAAw
CAYGZ4EMAQIBMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6Ly9jcmwudXNlcnRydXN0
LmNvbS9VU0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDB2Bggr
BgEFBQcBAQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNlcnRydXN0LmNv
bS9VU0VSVHJ1c3RSU0FBZGRUcnVzdENBLmNydDAlBggrBgEFBQcwAYYZaHR0cDov
L29jc3AudXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwFAAOCAgEAMr9hvQ5Iw0/H
ukdN+Jx4GQHcEx2Ab/zDcLRSmjEzmldS+zGea6TvVKqJjUAXaPgREHzSyrHxVYbH
7rM2kYb2OVG/Rr8PoLq0935JxCo2F57kaDl6r5ROVm+yezu/Coa9zcV3HAO4OLGi
H19+24rcRki2aArPsrW04jTkZ6k4Zgle0rj8nSg6F0AnwnJOKf0hPHzPE/uWLMUx
RP0T7dWbqWlod3zu4f+k+TY4CFM5ooQ0nBnzvg6s1SQ36yOoeNDT5++SR2RiOSLv
xvcRviKFxmZEJCaOEDKNyJOuB56DPi/Z+fVGjmO+wea03KbNIaiGCpXZLoUmGv38
sbZXQm2V0TP2ORQGgkE49Y9Y3IBbpNV9lXj9p5v//cWoaasm56ekBYdbqbe4oyAL
l6lFhd2zi+WJN44pDfwGF/Y4QA5C5BIG+3vzxhFoYt/jmPQT2BVPi7Fp2RBgvGQq
6jG35LWjOhSbJuMLe/0CjraZwTiXWTb2qHSihrZe68Zk6s+go/lunrotEbaGmAhY
LcmsJWTyXnW0OMGuf1pGg+pRyrbxmRE1a6Vqe8YAsOf4vmSyrcjC8azjUeqkk+B5
yOGBQMkKW+ESPMFgKuOXwIlCypTPRpgSabuY0MLTDXJLR27lk8QyKGOHQ+SwMj4K
00u/I5sUKUErmgQfky3xxzlIPK1aEn8=
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIFgTCCBGmgAwIBAgIQOXJEOvkit1HX02wQ3TE1lTANBgkqhkiG9w0BAQwFADB7
MQswCQYDVQQGEwJHQjEbMBkGA1UECAwSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHDAdTYWxmb3JkMRowGAYDVQQKDBFDb21vZG8gQ0EgTGltaXRlZDEhMB8GA1UE
AwwYQUFBIENlcnRpZmljYXRlIFNlcnZpY2VzMB4XDTE5MDMxMjAwMDAwMFoXDTI4
MTIzMTIzNTk1OVowgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpOZXcgSmVyc2V5
MRQwEgYDVQQHEwtKZXJzZXkgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBO
ZXR3b3JrMS4wLAYDVQQDEyVVU0VSVHJ1c3QgUlNBIENlcnRpZmljYXRpb24gQXV0
aG9yaXR5MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAgBJlFzYOw9sI
s9CsVw127c0n00ytUINh4qogTQktZAnczomfzD2p7PbPwdzx07HWezcoEStH2jnG
vDoZtF+mvX2do2NCtnbyqTsrkfjib9DsFiCQCT7i6HTJGLSR1GJk23+jBvGIGGqQ
Ijy8/hPwhxR79uQfjtTkUcYRZ0YIUcuGFFQ/vDP+fmyc/xadGL1RjjWmp2bIcmfb
IWax1Jt4A8BQOujM8Ny8nkz+rwWWNR9XWrf/zvk9tyy29lTdyOcSOk2uTIq3XJq0
tyA9yn8iNK5+O2hmAUTnAU5GU5szYPeUvlM3kHND8zLDU+/bqv50TmnHa4xgk97E
xwzf4TKuzJM7UXiVZ4vuPVb+DNBpDxsP8yUmazNt925H+nND5X4OpWaxKXwyhGNV
icQNwZNUMBkTrNN9N6frXTpsNVzbQdcS2qlJC9/YgIoJk2KOtWbPJYjNhLixP6Q5
D9kCnusSTJV882sFqV4Wg8y4Z+LoE53MW4LTTLPtW//e5XOsIzstAL81VXQJSdhJ
WBp/kjbmUZIO8yZ9HE0XvMnsQybQv0FfQKlERPSZ51eHnlAfV1SoPv10Yy+xUGUJ
5lhCLkMaTLTwJUdZ+gQek9QmRkpQgbLevni3/GcV4clXhB4PY9bpYrrWX1Uu6lzG
KAgEJTm4Diup8kyXHAc/DVL17e8vgg8CAwEAAaOB8jCB7zAfBgNVHSMEGDAWgBSg
EQojPpbxB+zirynvgqV/0DCktDAdBgNVHQ4EFgQUU3m/WqorSs9UgOHYm8Cd8rID
ZsswDgYDVR0PAQH/BAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wEQYDVR0gBAowCDAG
BgRVHSAAMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2EuY29t
L0FBQUNlcnRpZmljYXRlU2VydmljZXMuY3JsMDQGCCsGAQUFBwEBBCgwJjAkBggr
BgEFBQcwAYYYaHR0cDovL29jc3AuY29tb2RvY2EuY29tMA0GCSqGSIb3DQEBDAUA
A4IBAQAYh1HcdCE9nIrgJ7cz0C7M7PDmy14R3iJvm3WOnnL+5Nb+qh+cli3vA0p+
rvSNb3I8QzvAP+u431yqqcau8vzY7qN7Q/aGNnwU4M309z/+3ri0ivCRlv79Q2R+
/czSAaF9ffgZGclCKxO/WIu6pKJmBHaIkU4MiRTOok3JMrO66BQavHHxW/BBC5gA
CiIDEOUMsfnNkjcZ7Tvx5Dq2+UUTJnWvu6rvP3t3O9LEApE9GQDTF1w52z97GA1F
zZOFli9d31kWTz9RvdVFGD/tSo7oBmF0Ixa1DVBzJ0RHfxBdiSprhTEUxOipakyA
vGp4z7h/jnZymQyd/teRCBaho1+V
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIEMjCCAxqgAwIBAgIBATANBgkqhkiG9w0BAQUFADB7MQswCQYDVQQGEwJHQjEb
MBkGA1UECAwSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHDAdTYWxmb3JkMRow
GAYDVQQKDBFDb21vZG8gQ0EgTGltaXRlZDEhMB8GA1UEAwwYQUFBIENlcnRpZmlj
YXRlIFNlcnZpY2VzMB4XDTA0MDEwMTAwMDAwMFoXDTI4MTIzMTIzNTk1OVowezEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgMEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UE
BwwHU2FsZm9yZDEaMBgGA1UECgwRQ29tb2RvIENBIExpbWl0ZWQxITAfBgNVBAMM
GEFBQSBDZXJ0aWZpY2F0ZSBTZXJ2aWNlczCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAL5AnfRu4ep2hxxNRUSOvkbIgwadwSr+GB+O5AL686tdUIoWMQua
BtDFcCLNSS1UY8y2bmhGC1Pqy0wkwLxyTurxFa70VJoSCsN6sjNg4tqJVfMiWPPe
3M/vg4aijJRPn2jymJBGhCfHdr/jzDUsi14HZGWCwEiwqJH5YZ92IFCokcdmtet4
YgNW8IoaE+oxox6gmf049vYnMlhvB/VruPsUK6+3qszWY19zjNoFmag4qMsXeDZR
rOme9Hg6jc8P2ULimAyrL58OAd7vn5lJ8S3frHRNG5i1R8XlKdH5kBjHYpy+g8cm
ez6KJcfA3Z3mNWgQIJ2P2N7Sw4ScDV7oL8kCAwEAAaOBwDCBvTAdBgNVHQ4EFgQU
oBEKIz6W8Qfs4q8p74Klf9AwpLQwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQF
MAMBAf8wewYDVR0fBHQwcjA4oDagNIYyaHR0cDovL2NybC5jb21vZG9jYS5jb20v
QUFBQ2VydGlmaWNhdGVTZXJ2aWNlcy5jcmwwNqA0oDKGMGh0dHA6Ly9jcmwuY29t
b2RvLm5ldC9BQUFDZXJ0aWZpY2F0ZVNlcnZpY2VzLmNybDANBgkqhkiG9w0BAQUF
AAOCAQEACFb8AvCb6P+k+tZ7xkSAzk/ExfYAWMymtrwUSWgEdujm7l3sAg9g1o1Q
GE8mTgHj5rCl7r+8dFRBv/38ErjHT1r0iWAFf2C3BUrz9vHCv8S5dIa2LX1rzNLz
Rt0vxuBqw8M0Ayx9lt1awg6nCpnBBYurDC/zXDrPbDdVCYfeU0BsWO/8tqtlbgT2
G9w84FoVxp7Z8VlIMCFlA2zs6SFz7JsDoeA3raAVGI/6ugLOpyypEBMs1OUIJqsi
l2D4kF501KKaU73yqWjgom7C12yxow+ev+to51byrvLjKzg6CYG1a4XXvi3tPxq3
smPi9WIsgtRqAEFQ8TmDn5XpNpaYbg==
-----END CERTIFICATE-----
EOL

cat <<EOL >> key.pem
-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC5+aQoW3Z6EVh5
ump97Y3BvTPoXQnbI+0E2Hx8gQdsjPwOSnrQX7Rtb7UCXZI9Hh9a1VH3Ugn2WdR6
fJBX6R/9I5yv3y9CA4XCdx9N73IMXnSyPiXKP/OVGU3YMTQYcuZ197UhHXmYJ/+b
uf8+0OyQzvV8GjWOszxs8+k3RCTAJOHJjyIq0dKrD3YYVWiKcj4djj/WStmWivmN
CYVdVF7e1rrgZV9q9+ye+0U/OUPIBvW/NmicDLpSeQs+ErxNMytALjH5gYJmDIyB
dfSKbCO1IUaW6LyQ7h2cpPHgGZnH2iS6FZFDI/xVmNAfon8w3SEV3cUySKKBySus
3+w3Gpj7AgMBAAECggEABy9h7D08YpLw/CL7oknfRDDvJHcTvmew7JMAnD7P7p2z
z0mJXSuVaPT75U+AKuRTCctcE1YUFHR8BQ9y9DKJjdomX5Ub2k0QiebYSsaJfXjY
wVotU5cM7iHAJC4ieR9XUA917AWbgQlqkrWo6uBfg2i7i0Pn9c9u8jaqN/xl/xZc
1O36JEdrd6g1BTHh4a2bZ1P4iqCR24ISB0jGZvTf0qSSLKbKOQpMdSqjBfteVc64
1h3MMNKJtwI1nr+WfJCa5va1cfQ8OfzFXV1ha3c/+jaVS3JVgnJ6ogZ5vw0FXbI7
oWunOasC/qkjUONyeeLWzUtO6towsGKl8+pLaIKhQQKBgQDgYyLTmuNRH4DdKqwG
GnLk93R4YeVRo+u7mJOrfGqf1rxhdVBTq2lZBPRI6YuK7qaj7U7Ee4vp8azRyPqf
tspQ3RoLDHkdbDJKykFDT2dm/LtPopBGCeu4wUbHR5BbIQjMrGKI+pMV/VY3tkzU
Zf9130vkSWzjfhYenecYYoJRwwKBgQDULR2JyMwn20Lm1x/5VPPqPgZhRv0kDBum
KMB/uCOzwbGFYHg+UYBFMpYh4i0VV9qXs06JK40YNYg3viw1Pe7FZo4/H9H7Ml75
G6EzXopA0Z46sT+yTZUXKBig8AQltQNbunXmLaXc37qCXiLGKI8kH03p/i5Lfk6E
gjUnqruwaQKBgGG4KsmWsZp5qsgmtkXuLM00Sx/GGnVEevv2xZCwHUtA3EdhLLtT
cgyXkL9UHjZCGoZXaa890r/uRQITkboOg+tVbusS4ogCv6A8ltF2eiSqufRDaqtl
1KdgXK+ape5Z45gnFr5qybWQ34RhuvHg/bDarxVbOLWWCpII2ESRWgm7AoGAaprA
XJom+V+RHaq4xe2JIAhJ7FZemd37hmCzV3iNd6O6LelqgOUyLZJdHGknfbHGgrH0
o7beDWvYJSnHzHhxn30Hu2+hcTS9wyu+srCthiPL/HFSL6QLZLcgqLvvWYK5TT1C
P4Rv8an3a8kgb6+xO9T+sLKlUAkGKk3Bp0yBQQECgYATrNIEMLMAoBtv8GRoSaFa
mQBrQV8difAYM+yRddIEC2kIjB85ztbOL+freDZqcFZiG4MKjL27L+hI9cNaKGVa
gxP+c2C9UlgdIA7VdNsPT8a0sHEuQlp25CMwoOnWRKfE/3V7DshHzHhXC3SQQ1FK
YeRNs/BhYYgB/SjeTIOdzA==
-----END PRIVATE KEY-----
EOL

chmod 644 key.pem cert.pem
kubectl -n staging create secret tls ibosio-ingress-tls --key key.pem --cert cert.pem

cat <<EOL >> ibos_ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
     
  name: ing-ibosapp
spec:
  ingressClassName: ibosio-ingress
  rules:
    #madina.ibos.local
    - host: test.ibos.io
      http:
        paths:
          - pathType: Prefix
            path: /
            backend:
              service:
                name: front
                port:
                  number: 80
          - pathType: Prefix
            path: /identity
            backend:
              service:
                name: identity
                port:
                  number: 80
          - pathType: Prefix
            path: /vat
            backend:
              service:
                name: vatapi
                port:
                  number: 80



  tls:
    - hosts:
        - test.ibos.io
       

      secretName: ibosio-ingress-tls
EOL

chmod +x ibos_ingress.yaml
kubectl -n staging apply -f ibos_ingress.yaml

kubectl -n staging create secret docker-registry dockercred --docker-server=https://index.docker.io --docker-username=iboslimitedbd --docker-password=iBOS@ltd21 --docker-email=iboslimitedbd@gmail.com
kubectl get node
kubectl get pods

#sshpass -p "ibos@123" sftp -o StrictHostKeyChecking=no ibos@10.209.99.110:/home/ibos/ <<< "put /home/ibos/token.sh"

rm ~/.bash_history
history -c
#sshpass -p "ibos@123" ssh -o StrictHostKeyChecking=no ibos@10.209.99.120 'echo "ibos@123" | sudo -S sh -c "git clone https://github.com/kausar3033/kubernetes-full-process.git && cd kubernetes-full-process/ && chmod +x single2.sh && sed -i '\''s/\r$//'\'' single2.sh && mv single2.sh /home/ibos && cd /home/ibos && ./single2.sh"'

kubectl get node
kubectl get pods
rm ~/.bash_history
history -c
rm -rf kubernetes-full-process single.sh
rm ~/.bash_history
history -c
