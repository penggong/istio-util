wget https://github.com/prometheus-operator/kube-prometheus/archive/refs/tags/v0.10.0.tar.gz
tar -zxvf v0.10.0.tar.gz && cd kube-prometheus-0.10.0
kubectl apply --server-side -f manifests/setup
kubectl apply -f manifests/