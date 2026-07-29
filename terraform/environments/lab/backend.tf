##############################################################
# Project : AWS Threat Detection and Log Correlation Lab
# File    : backend.tf
#
# Purpose:
# This backend stores Terraform state in Amazon S3 so that
# local Terraform commands and GitHub Actions use the same
# infrastructure state.
#
# Security controls:
# - S3 server-side encryption
# - S3 bucket versioning
# - Native S3 state locking
#
# Important:
# The state bucket is created separately as a bootstrap
# resource so that the lab cannot destroy its own backend.
##############################################################

terraform {
  ############################################################
  # Amazon S3 Remote Backend
  #
  # The key identifies the state file for the lab environment.
  #
  # use_lockfile prevents two Terraform operations from
  # modifying the same state simultaneously.
  ############################################################
  backend "s3" {
    bucket       = "aws-threat-detection-lab-tfstate-905418310734"
    key          = "environments/lab/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}
