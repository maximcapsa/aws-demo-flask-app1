output "alb_url" {
  description = "Application URL (live after first successful pipeline run)"
  value       = "http://${aws_lb.main.dns_name}"
}

output "alb_test_url" {
  description = "Test listener URL — CodeDeploy routes canary traffic here before cutover"
  value       = "http://${aws_lb.main.dns_name}:8080"
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.app.repository_url
}

output "pipeline_name" {
  description = "CodePipeline name"
  value       = aws_codepipeline.app.name
}

output "ecs_cluster" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service" {
  description = "ECS service name"
  value       = aws_ecs_service.app.name
}

output "artifact_bucket" {
  description = "S3 bucket used for pipeline artifacts"
  value       = aws_s3_bucket.artifacts.bucket
}

output "codestar_connection_arn" {
  description = "GitHub connection ARN — IMPORTANT: activate this in the AWS Console before pushing to trigger the pipeline"
  value       = aws_codestarconnections_connection.github.arn
}
