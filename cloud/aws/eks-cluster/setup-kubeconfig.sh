region=$(grep -A 1 "variable \"region\"" variables.tf | grep -oP '(?<= = ").*(?=")')
aws eks update-kubeconfig --region ${region} --name eks-cluster
