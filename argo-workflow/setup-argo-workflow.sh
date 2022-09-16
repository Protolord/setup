# Create argo-workflow controllers in the cluster
kubectl create namespace argo
kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v3.3.9/install.yaml

# Port forward to allow local access
kubectl -n argo port-forward deployment/argo-server 2746:2746

# Bypass credentials
argo server --auth-mode server


