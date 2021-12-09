# Clean node
rm -rf $HOME/.kube
kubectl drain debian10 --delete-emptydir-data --force --ignore-daemonsets
sudo kubeadm reset

# Clean IP tables
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
ipvsadm -C

# Remove node
kubectl delete node debian10
