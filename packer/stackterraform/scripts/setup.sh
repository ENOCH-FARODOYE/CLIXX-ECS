#!/bin/bash
set -ex  # Exit on error and print commands

echo "=========================================="
echo "Starting ECS AMI Setup"
echo "=========================================="

# Update system
echo "1. Updating system packages..."
sudo yum update -y
sudo yum install -y git wget curl vim

# Install Docker
echo "2. Installing Docker..."
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# Verify Docker
docker --version || { echo "Docker installation failed"; exit 1; }

# Install ECS Agent
echo "3. Installing ECS Agent..."
sudo yum install -y ecs-init

# Verify ecs-init installed
rpm -qa | grep ecs-init || { echo "ecs-init installation failed"; exit 1; }

# Create ECS config directory
sudo mkdir -p /etc/ecs
sudo mkdir -p /var/log/ecs
sudo mkdir -p /var/lib/ecs/data

# Create base ECS config (cluster name will be set by user data at launch)
sudo tee /etc/ecs/ecs.config > /dev/null <<ECSEOF
ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs","fluentd","gelf","journald","logentries","splunk","syslog"]
ECS_ENABLE_TASK_IAM_ROLE=true
ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true
ECS_ENABLE_CONTAINER_METADATA=true
ECS_ENABLE_TASK_CPU_MEM_LIMIT=true
ECSEOF

# Enable ECS service (will start on boot)
echo "4. Enabling ECS service..."
sudo systemctl enable ecs

# Verify ECS service exists
sudo systemctl list-unit-files | grep ecs.service || { echo "ECS service not found"; exit 1; }

echo "5. Installing CloudWatch Agent..."
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
rm -f amazon-cloudwatch-agent.rpm

# TCP keepalive optimization
echo "6. Configuring TCP keepalive..."
sudo tee -a /etc/sysctl.conf > /dev/null <<SYSCTLEOF
net.ipv4.tcp_keepalive_time=200
net.ipv4.tcp_keepalive_intvl=200
net.ipv4.tcp_keepalive_probes=5
SYSCTLEOF

sudo sysctl -p

# File descriptors
echo "7. Configuring file descriptors..."
sudo tee -a /etc/security/limits.conf > /dev/null <<LIMITSEOF
*  soft  nofile  65536
*  hard  nofile  65536
LIMITSEOF

# Docker optimization
echo "8. Optimizing Docker configuration..."
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json > /dev/null <<DOCKEREOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
DOCKEREOF

sudo systemctl restart docker

# Final verification
echo "=========================================="
echo "Verification:"
echo "Docker version: $(docker --version)"
echo "ECS init package: $(rpm -qa | grep ecs-init)"
echo "ECS service status: $(sudo systemctl list-unit-files | grep ecs.service)"
echo "=========================================="
echo "Setup complete!"
echo "=========================================="
