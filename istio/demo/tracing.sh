kubectl apply -f jaeger.yaml
sleep 10
istioctl dashboard jaeger
