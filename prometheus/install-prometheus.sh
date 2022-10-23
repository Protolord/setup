# Clone the community repository of the prometheus stac
BASEDIR=$(dirname "$0")
OPERATOR_DIR="kube-prometheus"
if [[ -d ${BASEDIR}/${OPERATOR_DIR} ]]; then
  rm -rf $BASEDIR/${OPERATOR_DIR}
fi
git clone https://github.com/prometheus-operator/kube-prometheus.git -b release-0.11 ${BASEDIR}/${OPERATOR_DIR}

# Install CRDs and operator
kubectl create -f ${BASEDIR}/${OPERATOR_DIR}/manifests/setup
kubectl apply -f ${BASEDIR}/${OPERATOR_DIR}/manifests
kubectl -n monitoring get po
