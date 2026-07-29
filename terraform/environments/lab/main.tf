data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

resource "random_id" "suffix" {
  byte_length = 4
}

##############################################################
# Networking Module
#
# Creates the complete network foundation for the AWS threat
# detection and log-correlation lab.
#
# The selected Availability Zones were verified as available
# in the us-east-2 Region before deployment.
##############################################################
module "networking" {
  source = "../../modules/networking"

  project_name          = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  availability_zone_a   = var.availability_zone_a
  availability_zone_b   = var.availability_zone_b
  public_subnet_a_cidr  = var.public_subnet_a_cidr
  public_subnet_b_cidr  = var.public_subnet_b_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
}
