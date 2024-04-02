# Add dependencies for installation
sudo apt update
sudo apt install -y apt-transport-https gnupg2 curl

# Add GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Determine distro
if [ -f /etc/os-release ]; then
  . /etc/os-release
  distro=$NAME
  echo "Detected Linux distro: ${distro}"
else
  echo "Unable to determine Linux distro"
  read -p "Enter your distro (Debian/Ubuntu): " distro
fi
# Add repository
if [[ $distro =~ "Debian" ]]; then
  kube_repo="deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /"
  echo $kube_repo | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
elif [[ $distro =~ "Ubuntu" ]]; then
  kube_repo="deb https://apt.kubernetes.io/ kubernetes-xenial main"
  echo $kube_repo | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
fi

# Install kubernetes components
sudo apt update
sudo apt install -y kubectl kubelet kubeadm
kubectl version --client
kubelet --version

# Add auto-completion
if ! grep -q "source <(kubectl completion bash)" ~/.bashrc; then
  echo "source <(kubectl completion bash)" >>~/.bashrc
fi
# Use vim as default editor
if ! grep -q "export KUBE_EDITOR=vim" ~/.bashrc; then
  echo "export KUBE_EDITOR=vim" >>~/.bashrc
fi
