VERSION="1.0.11"
cd ${HOME}
curl -o "terraform_${VERSION}.zip" \
    -LO "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip"

unzip "terraform_${VERSION}.zip"
chmod +x terraform
sudo mv terraform /usr/local/bin
terraform -install-autocomplete
