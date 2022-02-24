user_name=kube
user_pwd=123456

###---1.install docker begin---####
sudo yum update
sudo yum install docker
sudo systemctl start docker
sudo systemctl enable docker

sudo groupadd docker
sudo systemctl restart docker

echo "docker had install"
###---install docker end---####

###---2.insert docker group,add user ---###
useradd $user_name
passwd $user_name $user_pwd
sudo usermod -aG docker $user_name

###---3.install kubectl begin---####
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256)  kubectl" | sha256sum --check

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

kubectl version --client

###---4.install minikube begin---####
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

su $user_name

minikube start --registry-mirror=https://registry.docker-cn.com --vm-driver=docker

