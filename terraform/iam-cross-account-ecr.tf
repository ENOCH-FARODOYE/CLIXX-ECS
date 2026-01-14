# Cross-account ECR access for ECS task execution role
resource "aws_iam_role_policy" "cross_account_ecr" {
  name = "${var.project_name}-${var.environment}-cross-account-ecr"
  role = aws_iam_role.ecs_task_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "arn:aws:ecr:us-east-1:451873237827:repository/clixx-app"
      }
    ]
  })
}
