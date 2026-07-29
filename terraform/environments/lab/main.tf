data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

resource "random_id" "suffix" {
  byte_length = 4
}

##############################################################
# Networking Module
#
# Creates the network foundation for the threat detection and
# log correlation lab.
#
# Resources created by this module:
# - Custom VPC
# - Two public subnets
# - Two private subnets
# - Internet Gateway
# - NAT Gateway
# - Public and private route tables
# - Route table associations
#
# Later modules will consume the network identifiers produced
# by this module when creating EC2, ALB, RDS, VPC Flow Logs,
# Route 53 Resolver logging, and other security resources.
##############################################################
module "networking" {
  source = "../../modules/networking"

  project_name          = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  public_subnet_a_cidr  = var.public_subnet_a_cidr
  public_subnet_b_cidr  = var.public_subnet_b_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
}
