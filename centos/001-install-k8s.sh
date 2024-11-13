echo "yum prepare"
sudo yum update
sudo yum install docker
sudo systemctl start docker
sudo systemctl enable docker

sudo groupadd docker
sudo usermod -aG docker root
sudo systemctl restart docker

sudo yum install conntrack

echo "kubectl downloading"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

kubectl version

#
echo "k8s 1.23.3 downloading"
curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v1.25.2/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

echo "minikube starting"
minikube start --registry-mirror=https://registry.docker-cn.com --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers --vm-driver=docker --alsologtostderr -v=8 --driver=none
