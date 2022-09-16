# Check kubernetes binaries
for item in kubeadm kubelet kubectl; do
  if [[ ! $(which ${item}) ]]; then
    echo "No ${item} was found on this machine, setup cancelled"
    exit 1
  fi
done

# Turn off swap
sudo swapoff -a

# Kernel settings
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

# Containerd setup
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

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
kubectl cluster-info
sleep 5s
kubectl get nodes
sudo journalctl -u containerd -e | tail -n 3
sudo journalctl -u kubelet -e | tail -n 3

# Install calico
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.1/manifests/tigera-operator.yaml
if [[ ${cidr} == "192.168.0.0/16" ]]; then
  kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.1/manifests/custom-resources.yaml
else
  wget https://raw.githubusercontent.com/projectcalico/calico/v3.24.1/manifests/custom-resources.yaml
  sed -i "s|192.168.0.0/16|${cidr}|g" ./custom-resources.yaml
  kubectl apply -f ./custom-resources.yaml
  rm ./custom-resources.yaml
fi

# Confirm calico pods are running
kubectl -n calico-system wait --for='condition=Ready' pods --all

read -p "Untaint master node (y/n)?" is_tainted
if [[ $is_tainted == "y" || $is_tainted == "Y" ]]; then
  kubectl taint nodes --all node-role.kubernetes.io/master-
  kubectl taint nodes --all node-role.kubernetes.io/control-plane-
fi
