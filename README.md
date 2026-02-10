# CLIXX - ECS Containerized Application Deployment

Production deployment of the CLIXX web application on Amazon ECS with Terraform automation, featuring multi-AZ architecture, auto-scaling, and managed container orchestration.

## Overview

This repository contains the complete ECS infrastructure and deployment configuration for CLIXX, a retail web application. The architecture uses both Fargate and EC2 launch types for flexible workload placement, with comprehensive monitoring and automated deployments via Jenkins.

## Architecture

The CLIXX application runs on Amazon ECS with the following components:

**Container Orchestration:**
- ECS cluster with dual launch type support (Fargate and EC2)
- Task definitions with optimized resource allocation
- Service auto-scaling based on CPU and memory metrics
- Rolling update deployment strategy for zero downtime

**Network & Load Balancing:**
- Application Load Balancer for traffic distribution
- Target group health checks with configurable thresholds
- Multi-AZ deployment across us-east-1a and us-east-1b
- VPC integration with public and private subnets

**Database:**
- Amazon RDS MySQL with Multi-AZ configuration
- Automated backups and point-in-time recovery
- Security groups restricting access to ECS tasks only
- Connection pooling for optimal performance

**Monitoring & Logging:**
- CloudWatch Logs for container output
- CloudWatch Metrics for service monitoring
- Custom dashboards for application health
- Alarms for critical metrics (CPU, memory, error rates)

## Infrastructure Components

### ECS Cluster Configuration

The cluster supports both Fargate and EC2 launch types:

**Fargate Tasks:**
- Serverless container execution
- No infrastructure management required
- Automatic scaling based on demand
- Pay-per-use pricing model

**EC2 Tasks:**
- Greater control over underlying instances
- Cost optimization for predictable workloads
- Custom AMI support
- Reserved Instance pricing available

### Application Load Balancer

**Features:**
- HTTP/HTTPS traffic routing
- Path-based routing for microservices
- Health checks with configurable intervals
- SSL/TLS termination
- Access logs to S3 for audit compliance

### Task Definitions

Container specifications include:

- Docker image from Amazon ECR
- Environment variable configuration
- Secrets management via AWS Systems Manager
- Resource limits (CPU and memory)
- Port mappings for application access
- Log configuration for CloudWatch

## Deployment Process

### Automated via Jenkins

The deployment pipeline follows these stages:

1. **Build** - Docker image creation from application code
2. **Test** - Automated testing and validation
3. **Push** - Image upload to Amazon ECR with version tags
4. **Deploy** - ECS service update with new task definition
5. **Verify** - Health check validation post-deployment

### Manual Deployment

For manual deployments or troubleshooting:

```bash
# Update task definition with new image
aws ecs register-task-definition --cli-input-json file://task-definition.json

# Update service to use new task definition
aws ecs update-service \
  --cluster clixx-cluster \
  --service clixx-service \
  --task-definition clixx-task:REVISION

# Monitor deployment status
aws ecs describe-services \
  --cluster clixx-cluster \
  --services clixx-service
```

## Security Configuration

### Network Security

- Private subnets for ECS tasks (no direct internet access)
- Security groups with least-privilege rules
- NAT Gateway for outbound internet connectivity
- VPC endpoints for AWS service access (reduce NAT costs)

### Application Security

- Secrets stored in AWS Systems Manager Parameter Store
- IAM roles for task execution (no long-lived credentials)
- Encryption at rest for database
- Encryption in transit (HTTPS only)

### Access Control

- IAM policies following least-privilege principle
- CloudTrail logging for audit compliance
- Resource tagging for cost allocation
- MFA enforcement for production changes

## Scaling Configuration

### Service Auto-Scaling

The ECS service scales automatically based on:

**Target Tracking Policies:**
- CPU utilization target: 70%
- Memory utilization target: 80%
- Request count per target: 1000/minute

**Scaling Limits:**
- Minimum tasks: 2 (for high availability)
- Maximum tasks: 10 (cost control)
- Scale-out cooldown: 60 seconds
- Scale-in cooldown: 300 seconds

### Cluster Auto-Scaling

For EC2 launch type:

- EC2 instances scale based on ECS cluster capacity
- Capacity provider manages instance lifecycle
- Warm pool for faster scale-out
- Graceful termination for scale-in

## Cost Optimization

**Strategies Implemented:**

- Right-sized task resources (no over-provisioning)
- Fargate Spot for non-critical workloads
- Reserved Instances for baseline EC2 capacity
- S3 lifecycle policies for log retention
- CloudWatch log retention policies (30 days)
- VPC endpoints to reduce NAT Gateway costs

**Estimated Monthly Cost:**
- ECS tasks (Fargate): $50-100 depending on scale
- RDS Multi-AZ MySQL: $75-120 (db.t3.medium)
- Application Load Balancer: $20-25
- Data transfer: $10-20
- **Total: ~$155-265/month** for production environment

## Monitoring & Alerts

### CloudWatch Dashboards

Custom dashboards track:

- Service health (running task count, failed deployments)
- Application performance (response time, error rate)
- Resource utilization (CPU, memory, network)
- Database metrics (connections, queries, replication lag)

### Alarms

Critical alarms configured for:

- High CPU utilization (>80% for 5 minutes)
- High memory utilization (>85% for 5 minutes)
- Failed task launches
- Unhealthy target count in ALB
- Database connection failures

Notifications sent to SNS topic for team alerting.

## Disaster Recovery

**Backup Strategy:**

- RDS automated backups (7-day retention)
- Daily manual snapshots (30-day retention)
- Application code in version control
- Infrastructure as code in this repository

**Recovery Procedures:**

- Database restore from snapshot: ~15-30 minutes
- Application redeployment: ~5-10 minutes
- Full stack recreation: ~30-45 minutes

**RTO:** 1 hour
**RPO:** 5 minutes (database transaction logs)

## Maintenance

### Regular Tasks

**Weekly:**
- Review CloudWatch logs for errors
- Check scaling metrics and adjust if needed
- Review cost reports and optimize

**Monthly:**
- Rotate access credentials
- Review and update task definitions
- Security patch assessment
- Backup verification testing

**Quarterly:**
- Disaster recovery drill
- Capacity planning review
- Cost optimization audit

## Troubleshooting

### Common Issues

**Tasks Not Starting:**
- Check task definition for invalid configuration
- Verify ECR image exists and is accessible
- Review IAM role permissions for task execution
- Check security group rules for network connectivity

**Application Performance Issues:**
- Review CloudWatch metrics for bottlenecks
- Check RDS database performance insights
- Verify ALB target health checks
- Analyze CloudWatch Logs for application errors

**Deployment Failures:**
- Check ECS service events for error messages
- Verify new task definition is valid
- Review health check configuration
- Check for capacity limitations in cluster

## Technology Stack

- **Container Orchestration:** Amazon ECS
- **Compute:** AWS Fargate and EC2
- **Load Balancing:** Application Load Balancer
- **Database:** Amazon RDS MySQL (Multi-AZ)
- **Container Registry:** Amazon ECR
- **Infrastructure as Code:** Terraform
- **CI/CD:** Jenkins
- **Monitoring:** CloudWatch
- **Networking:** VPC, Security Groups, NAT Gateway

## Related Repositories

- **STACK_TERRAFORM** - Complete infrastructure code including VPC, IAM, and S3
- **golden-ami-pipeline** - Automated AMI creation for EC2 instances

## Author

**Enoch Farodoye**

LinkedIn: [linkedin.com/in/enoch-farodoye](https://linkedin.com/in/enoch-farodoye)

Email: farodoyeenoch1@gmail.com

GitHub: [@ENOCH-FARODOYE](https://github.com/ENOCH-FARODOYE)

---

This deployment supports production workloads with high availability, automated scaling, and comprehensive monitoring. The infrastructure is fully managed via Terraform with zero-downtime deployment capabilities.
