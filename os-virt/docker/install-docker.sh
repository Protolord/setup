# Remove old versions
sudo apt remove docker docker-engine docker.io containerd runc

# Add dependencies for installation
sudo apt update
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add GPG key
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

# Add repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

# Install docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Add user to docker group
sudo usermod -aG docker $(whoami)

# Show docker version installed
docker --version

# Configure to use systemd for the management of the container’s cgroups
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Restart docker
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
