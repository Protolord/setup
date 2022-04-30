# Remove old versions
sudo apt remove -y docker docker-engine docker.io containerd runc

# Add dependencies for installation
sudo apt update
sudo apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

if [ -f /etc/os-release ]; then
  . /etc/os-release
  distro=$NAME
  echo "Detected Linux distro: ${distro}"
else
  echo "Unable to determine Linux distro"
  read -p "Enter your distro (Debian/Ubuntu): " distro
fi

if [[ $distro =~ "Debian" ]]; then
  docker_url="https://download.docker.com/linux/debian"
  # Add GPG key
  curl -fsSL ${docker_url}/gpg | sudo apt-key add -
  # Add repository
  sudo add-apt-repository "deb [arch=amd64] ${docker_url} $(lsb_release -cs) stable"
elif [[ $distro =~ "Ubuntu" ]]; then
  docker_url="https://download.docker.com/linux/ubuntu"
  gpg_path="/usr/share/keyrings/docker-archive-keyring.gpg"
  # Add GPG key
  curl -fsSL ${docker_url}/gpg | sudo gpg --dearmor -o $gpg_path
  # Add repository
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=${gpg_path}] ${docker_url} \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
else
  echo "Invalid Linux distro (${distro}), installation cancelled"
  exit 1
fi

# Install docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Add user to docker group
sudo usermod -aG docker $(whoami)

# Show docker version installed
docker --version

# Configure to use systemd for the management of the container’s cgroups
cat << EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Restart docker and bash
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
bash
