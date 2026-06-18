variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name prefix for all AWS resources"
  type        = string
  default     = "flask-pipeline"
}

variable "github_owner" {
  description = "GitHub repository owner (username or org)"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "Branch that triggers the pipeline"
  type        = string
  default     = "main"
}

variable "container_port" {
  description = "Port the Flask app listens on"
  type        = number
  default     = 5000
}

variable "task_cpu" {
  description = "ECS task CPU units (256 = 0.25 vCPU)"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "ECS task memory in MB"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Desired number of ECS tasks. Set to 0 on first apply if ECR is empty; the pipeline will bootstrap the image."
  type        = number
  default     = 1
}

variable "alarm_email" {
  description = "Email address to receive CloudWatch alarm notifications via SNS. Leave empty to skip the subscription."
  type        = string
  default     = ""
}

variable "min_capacity" {
  description = "Minimum number of ECS tasks (autoscaling floor)"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of ECS tasks (autoscaling ceiling — caps cost)"
  type        = number
  default     = 4
}
