arg=$1
if [ $arg == "start" ]; then
  elapsed_time=0
  interval=1
  while [ $elapsed_time -lt 15 ]; do
    sender_status=$(kubectl -n istio-demo-tx get pod -l app=sender-app -o jsonpath={.items..status.phase})
    receiver_status=$(kubectl -n istio-demo-rx get pod -l app=receiver-app -o jsonpath={.items..status.phase})
    if [ "$sender_status" == "Running" ] && [ "$receiver_status" == "Running" ]; then
      break
    fi
    if [ $elapsed_time -eq 0 ]; then
      echo "waiting for pods to be ready"
    fi
    sleep $interval
    ((elapsed_time += interval))
  done
  sender_pod=$(kubectl -n istio-demo-tx get pod -l app=sender-app -o jsonpath={.items..metadata.name})
  receiver_pod=$(kubectl -n istio-demo-rx get pod -l app=receiver-app -o jsonpath={.items..metadata.name})
  kubectl sniff -n istio-demo-tx -p ${sender_pod} -o pkt_sender.pcap &
  kubectl sniff -n istio-demo-rx -p ${receiver_pod} -o pkt_receiver.pcap &
elif [ $arg == "stop" ]; then
  ps aux | grep ksniff-container | awk {'print $2'} | xargs sudo kill
else
  echo "invalid argument '$arg'"
fi
