## Demo - Communication between services
Deploys 2 microservices (1 sender & 1 receiver) where the sender will send an HTTP request to the
receiver via the service mesh

## Setup
1. Update `setup.sh` variables to point to the correct container registry target image
1. Run `setup.sh` to initialize demo - build & push docker images, create k8s resources, etc.

## Functionalities
### Security
Requirement: ksniff
1. Run `./packet_capture.sh start` without istio installed
1. Observe captured packets after TCP handshake between pods which are in plain text
1. Stop packet capture via `./packet_capture stop`
1. Run `./packet_capture.sh start` with istio installed.
1. Observe that the captured packets are encrypted after TCP handshake between pods.
  The TCP payload containing the HTTP request starts with 0x170303 after the TLS handshake (0x16).

### Observability
1. Run `./tracing.sh`
1. View the Jaeger dashboard in your browser (port 16686)
