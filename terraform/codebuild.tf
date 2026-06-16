resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.app_name}-artifacts-${data.aws_caller_identity.current.account_id}"

  tags = { Name = "${var.app_name}-artifacts" }
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_codebuild_project" "app" {
  name          = var.app_name
  service_role  = aws_iam_role.codebuild.arn
  build_timeout = 20

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.app.name
    }

    environment_variable {
      name  = "CONTAINER_NAME"
      value = "flask-app"
    }

    environment_variable {
      name  = "TASK_EXECUTION_ROLE_ARN"
      value = aws_iam_role.ecs_task_execution.arn
    }

    environment_variable {
      name  = "TASK_ROLE_ARN"
      value = aws_iam_role.ecs_task.arn
    }

    environment_variable {
      name  = "LOG_GROUP_NAME"
      value = aws_cloudwatch_log_group.ecs.name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/codebuild/${var.app_name}"
      stream_name = "build"
    }
  }

  tags = { Name = var.app_name }
}
