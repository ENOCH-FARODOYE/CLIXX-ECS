#!/bin/bash
set -x

echo "Starting ECS setup"

# Update system
sudo yum update -y
sudo yum install git wget curl vim -y

# Install Docker
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
docker --version

# Install ECS Agent
sudo yum install -y ecs-init
sudo systemctl enable --now --no-block ecs
sudo mkdir -p /etc/ecs

# ECS config
sudo tee /etc/ecs/ecs.config > /dev/null <<EOF
ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs","fluentd","gelf","journald","logentries","splunk","syslog"]
ECS_ENABLE_TASK_IAM_ROLE=true
ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true
ECS_ENABLE_CONTAINER_METADATA=true
ECS_ENABLE_TASK_CPU_MEM_LIMIT=true
EOF

rpm -qa | grep ecs-init
echo "ECS Agent installed"

# Install CloudWatch Agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
rm -f amazon-cloudwatch-agent.rpm

# TCP keepalive
sudo /sbin/sysctl -w net.ipv4.tcp_keepalive_time=200 net.ipv4.tcp_keepalive_intvl=200 net.ipv4.tcp_keepalive_probes=5

# File descriptors
sudo tee -a /etc/security/limits.conf > /dev/null <<EOF
*  soft  nofile  65536
*  hard  nofile  65536
EOF

# Docker optimization
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl restart docker
echo "Setup complete"
