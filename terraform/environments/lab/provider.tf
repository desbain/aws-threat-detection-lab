provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Purpose     = "Threat-Detection-Log-Correlation-Lab"
      Owner       = var.owner
    }
  }
}
