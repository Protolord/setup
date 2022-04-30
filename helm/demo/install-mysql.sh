if [[ ! $(which helm) ]]; then
  echo "No helm was found on this machine, cannot install MySQL"
  exit 1
fi
# Setup chart repo, then pull the chart
BASEDIR=$(dirname "$0")
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
if [[ -d ${BASEDIR}/mysql ]]; then
  rm -rf $BASEDIR/mysql
fi
helm pull bitnami/mysql --destination ${BASEDIR} --untar

# Install OpenEBS
helm repo add openebs https://openebs.github.io/charts
helm repo update
helm upgrade --install openebs -n openebs openebs/openebs --create-namespace

# Install MySQL using OpenEBS storage class
sed -i 's|storageClass: ""|storageClass: "openebs-hostpath"|' ${BASEDIR}/mysql/values.yaml
helm upgrade --install mysql-demo -n mysql  $BASEDIR/mysql --create-namespace
