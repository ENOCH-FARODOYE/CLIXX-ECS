#!/bin/bash
set -e

IMAGE_NAME="clixx-app"
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="529206289534"
ECR_REPO="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}"
BUILD_NUMBER=${1:-latest}

echo "Building Docker image"
docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .

echo "Tagging image"
docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${ECR_REPO}:${BUILD_NUMBER}
docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${ECR_REPO}:latest

echo "Login to ECR"
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}

echo "Push to ECR"
docker push ${ECR_REPO}:${BUILD_NUMBER}
docker push ${ECR_REPO}:latest

echo "Build complete"
echo "Image: ${ECR_REPO}:${BUILD_NUMBER}"
