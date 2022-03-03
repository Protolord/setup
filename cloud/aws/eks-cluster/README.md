### Elastic Kubernetes Service Cluster
Creates a kubernetes cluster in the cloud where the control plane is managed by AWS.
The terraform configuration is hardcoded to create an EKS cluster named "eks-cluster".
All worker nodes (3× t2.micro instances) are public but only accepts SSH connection from the
configured IP.

After provisioning the AWS resources, run `setup-kubeconfig.sh` on your local machine.
