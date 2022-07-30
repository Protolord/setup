istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
istioctl tag remove default
kubectl delete namespace istio-system
