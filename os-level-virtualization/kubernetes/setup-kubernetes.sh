# Check kubernetes binaries
for item in kubeadm kubelet kubectl; do
  if [[ ! $(which ${item}) ]]; then
    echo "No ${item} was found on this machine, setup cancelled"
    exit 1
  fi
done

# Turn off swap
sudo swapoff -a

# Initialize cluster master
read -p "Enter cluster CIDR (default: 192.168.0.0/16): " cidr
if [[ ${cidr} == "" ]]; then
  cidr="192.168.0.0/16"
fi
sudo kubeadm init --pod-network-cidr=${cidr} || exit

# Configure kubectl
if [[ -d $HOME/.kube ]]; then
  rm -rf $HOME/.kube
fi
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install calico
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
if [[ ${cidr} == "192.168.0.0/16" ]]; then
  kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
else
  wget https://docs.projectcalico.org/manifests/custom-resources.yaml
  sed -i "s|192.168.0.0/16|${cidr}|g" ./custom-resources.yaml
  kubectl apply -f ./custom-resources.yaml
  rm ./custom-resources.yaml
fi

# Confirm calico pods are running
kubectl -n calico-system wait --for='condition=Ready' pods --all

read -p "Untaint master node (y/n)?" is_tainted
if [[ $is_tainted == "y" || $is_tainted == "Y" ]]; then
  kubectl taint nodes --all node-role.kubernetes.io/master-
fi
