sudo apt install curl wget

echo "Fetching latest Go version..."
href=$(curl https://go.dev/dl/ | grep -B 1 "<div class=\"platform\">Linux</div>" | grep -oP '(?<=href=").*(?=")')
default_version=$(echo ${href} | grep -oP '(?<=go).*(?=\.linux)')
read -p "Enter Go version to install (default: ${default_version}): " version
if [[ ${version} == "" ]]; then
  version=${default_version}
fi

wget https://golang.org/dl/go${version}.linux-amd64.tar.gz -P ${HOME} || exit
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf ${HOME}/go${version}.linux-amd64.tar.gz

if ! grep -q "export PATH=\$PATH:\/usr\/local\/go\/bin" ~/.bashrc; then
  echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
fi
source ${HOME}/.bashrc

sudo rm ${HOME}/go${version}.linux-amd64.tar.gz
bash
