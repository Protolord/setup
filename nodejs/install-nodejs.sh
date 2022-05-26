#!/usr/bin/env bash

version="lts"
read -p "Install Node.js current version (y/n)? " use_current
if [[ $use_current == "y" || $use_current == "Y" ]]; then
  version="current"
fi

curl -sL "https://deb.nodesource.com/setup_${version}.x" | sudo bash
sudo apt install -y nodejs

echo "Node.js version"
node -v
echo "Node Package Manager (npm) version"
npm -v
