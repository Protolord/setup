### Demo - Web Server
Deploys a containerized Apache web server in a kubernetes cluster. The web server's PHP source
code is mounted on this directory.

Don't forget to edit the `deployment.yaml` volume path based on your system.

To check packets using ksniff:
1. Install dependencies (e.g. libpcap-dev)
1. Install the ksniff plugin via `kubectl krew install sniff`
1. Start capture via `kubectl sniff -p <podname> -n default -o pkt_capture.pcap`
1. Open the packet capture file in Wireshark
