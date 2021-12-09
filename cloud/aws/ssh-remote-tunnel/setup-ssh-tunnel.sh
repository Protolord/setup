read -p "EC2 public IP: " public_ip
read -p "Exposed port: " exposed_port
read -p "Local running port: " local_port

ssh ec2-user@${public_ip} << 'ENDSSH'
sudo sed -i -r 's|(#?)GatewayPorts no|GatewayPorts yes|' /etc/ssh/sshd_config
sudo systemctl restart sshd
ENDSSH

ssh -fNTR ${exposed_port}:localhost:${local_port} ec2-user@${public_ip}
