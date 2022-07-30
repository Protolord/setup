echo "Fetching latest istio version..."
default_version="$(curl -sL https://github.com/istio/istio/releases | \
                grep -o 'releases/[0-9]*.[0-9]*.[0-9]*/' | sort -V | \
                tail -1 | awk -F'/' '{ print $2}')"
default_version="${default_version##*/}"
read -p "Enter istio version (${default_version}): " version
if [[ ${version} == "" ]]; then
  version=${default_version}
fi
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${version} TARGET_ARCH=x86_64 sh -

# Install istioctl in the machine
istio="istio-${version}"
sudo rm -rf /usr/local/${istio}
sudo mv ${istio} /usr/local
sudo ln -sf /usr/local/${istio}/bin/istioctl /usr/local/bin/istioctl

# Install istio using demo profile
istioctl install --set profile=demo -y
