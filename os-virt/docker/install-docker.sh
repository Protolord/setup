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
