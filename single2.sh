#!/bin/sh -x
set -x
export KUBECONFIG=/home/ibos/.kube/config
sudo apt-get update
apt install sshpass
apt-get install -y curl openssh-server

echo $(hostname -i) $(hostname) >> /etc/hosts
sudo sed -i "/swap/s/^/#/" /etc/fstab
sudo swapoff -a

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y ebtables ethtool
apt-get install -y docker.io

cat <<EOF >/etc/docker/daemon.json
{
  "bip": "172.123.0.1/16"
}
EOF

systemctl daemon-reload
systemctl restart docker

apt-get install -y apt-transport-https
apt-get install -qy kubelet=1.25.3-00 kubeadm=1.25.3-00 kubectl=1.25.3-00

chmod +x token.sh
sh token.sh

rm ~/.bash_history
history -c
rm -rf kubernetes-full-process single2.sh token.sh
rm ~/.bash_history
history -c
