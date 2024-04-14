SENDER_IMAGE=""
RECEIVER_IMAGE=""

docker login
docker build -t istio-demo/sender:latest ./sender
docker build -t istio-demo/receiver:latest ./receiver
docker tag istio-demo/sender ${SENDER_IMAGE}
docker tag istio-demo/receiver ${RECEIVER_IMAGE}
docker push ${SENDER_IMAGE}
docker push ${RECEIVER_IMAGE}

kubectl apply -f namespace.yaml
kubectl -n istio-demo-tx get secret dockerhub-secret &> /dev/null || kubectl create secret generic dockerhub-secret \
  --from-file=.dockerconfigjson=$HOME/.docker/config.json \
  --namespace=istio-demo-tx \
  --type=kubernetes.io/dockerconfigjson
kubectl -n istio-demo-rx get secret dockerhub-secret &> /dev/null || kubectl create secret generic dockerhub-secret \
  --from-file=.dockerconfigjson=$HOME/.docker/config.json \
  --namespace=istio-demo-rx \
  --type=kubernetes.io/dockerconfigjson

kubectl apply -f sender/service.yaml
kubectl apply -f receiver/service.yaml
sed "s|\${SENDER_IMAGE}|$SENDER_IMAGE|" sender/deployment.yaml | kubectl apply -f -
sed "s|\${RECEIVER_IMAGE}|$RECEIVER_IMAGE|" receiver/deployment.yaml | kubectl apply -f -
