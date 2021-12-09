### SSH remote tunnel
Provision a  lightweight (t2.micro) public EC2 instance on AWS that creates an SSH tunnel with your
local machine. The SSH tunnel forwards all traffic on a specific port from the EC2 instance into
your local machine allowing you to expose services on the internet.

After provisioning the AWS resources, run `setup-ssh-tunnel.sh` on your local machine.
