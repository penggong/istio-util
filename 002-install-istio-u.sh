echo "#### 1.下载 ###"
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.12.9 TARGET_ARCH=x86_64 sh -

echo "#### 2.进入目录 ###"
cd istio-1.12.9

export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled

kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT

kubectl get svc -A
