
echo "******8.安装conntrack ******"
sudo apt-get install conntrack

echo "******9.下载安装k8s ******"
curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v1.25.2/minikube-linux-amd64
chmod +x minikube && sudo mv minikube /usr/local/bin/

echo "******10 启动******"
minikube start --image-mirror-country=cn --driver=none
