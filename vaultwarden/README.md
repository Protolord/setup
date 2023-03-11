# Setup
1. Obtain a subdomain from Duck DNS
1. Make sure the subdomain is properly mapped to the correct IP in the network

# Installation
1. Edit the volume mount path in docker-compose.yaml to where you want to store persistent data
1. Edit the caddy container env var (domain, email, token) in docker-compose.yaml
1. Create and start the docker container: `docker-compose up -d`

# Access
1. Go to your subdomain using your web browser
