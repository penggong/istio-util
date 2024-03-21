kubectl apply -f samples/addons 
kubectl rollout status deployment/kiali -n istio-system
sleep 10
kubectl rollout status deployment/kiali -n istio-system

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/prometheus.yaml
echo "prometheus started!"

kubectl get svc -A