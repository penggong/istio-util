#卸载旧版本
echo "******1.卸载旧版本 ******"
sudo apt-get remove docker docker-engine docker-ce docker.io

echo "******2.添加阿里云GPG秘钥 ******"
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -

echo "******3.设置存储库 ******"
sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

echo "******4.安装docker ******"
sudo apt-get update

#ubuntu22 需要指定版本号，24版本不需要
#sudo apt-get install docker-ce=5:20.10.13~3-0~ubuntu-jammy docker-ce-cli=5:20.10.13~3-0~ubuntu-jammy containerd.io docker-compose-plugin
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo docker version

sudo systemctl status docker

echo "******5.依赖 ******"
sudo apt-get install -y apt-transport-https

echo "******6.添加阿里GPG  添加阿里apt源 ******"
sudo curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -

sudo tee /etc/apt/sources.list.d/kubernetes.list <<-'EOF'
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

sudo apt-get update

echo "******7.安装kubectl ******"
sudo apt-get install -y kubectl

#添加用户到docker组
echo "******7.1 添加用户到docker组 ******"
sudo usermod -aG docker $USER && newgrp docker

echo "******8.安装conntrack ******"
sudo apt-get install conntrack

echo "******9.下载安装k8s ******"
curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v1.25.2/minikube-linux-amd64
chmod +x minikube && sudo mv minikube /usr/local/bin/

echo "******10 启动******"
minikube start --image-mirror-country=cn --driver=none
