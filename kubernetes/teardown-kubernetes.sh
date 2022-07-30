# Check kubernetes binaries
for item in kubeadm kubelet kubectl; do
  if [[ ! $(which ${item}) ]]; then
    echo "No ${item} was found on this machine, teardown cancelled"
    exit 1
  fi
done
# Get all nodes
nodes=$(kubectl get nodes --no-headers -o custom-columns=":metadata.name")

# Drain
for node in ${nodes}; do
  kubectl drain ${node} --delete-emptydir-data --force --ignore-daemonsets
done

# Reset
sudo kubeadm reset

# Delete
for node in ${nodes}; do
  kubectl delete node ${node}
done
