output "aws_account_id" {
  description = "AWS account receiving the lab resources"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS Region used by the lab"
  value       = data.aws_region.current.region
}

output "aws_partition" {
  description = "AWS partition used by the account"
  value       = data.aws_partition.current.partition
}

output "resource_suffix" {
  description = "Unique suffix for globally named resources"
  value       = random_id.suffix.hex
}

##############################################################
# Threat Detection Lab VPC ID
#
# Returns the identifier of the VPC created by the networking
# module.
#
# This value will be used when validating the deployment and
# when connecting later infrastructure modules.
##############################################################
output "vpc_id" {
  description = "Unique identifier of the threat detection lab VPC."
  value       = module.networking.vpc_id
}

##############################################################
# VPC CIDR Block
#
# Returns the private IPv4 address range assigned to the VPC.
##############################################################
output "vpc_cidr_block" {
  description = "IPv4 CIDR block assigned to the threat detection lab VPC."
  value       = module.networking.vpc_cidr_block
}

##############################################################
# Public Subnet IDs
#
# Returns both public subnet identifiers.
#
# These values will later be passed to the Application Load
# Balancer module.
##############################################################
output "public_subnet_ids" {
  description = "Identifiers of the two public subnets."
  value       = module.networking.public_subnet_ids
}

##############################################################
# Private Subnet IDs
#
# Returns both private subnet identifiers.
#
# These values will later be passed to the EC2 and RDS modules.
##############################################################
output "private_subnet_ids" {
  description = "Identifiers of the two private subnets."
  value       = module.networking.private_subnet_ids
}

##############################################################
# NAT Gateway ID
#
# Returns the identifier of the NAT Gateway serving the private
# subnets.
##############################################################
output "nat_gateway_id" {
  description = "Unique identifier of the NAT Gateway."
  value       = module.networking.nat_gateway_id
}

##############################################################
# Availability Zones
#
# Returns the two Availability Zones selected by the networking
# module.
##############################################################
output "availability_zones" {
  description = "Availability Zones used by the lab network."
  value       = module.networking.availability_zones
}

##############################################################
# ALB Security Group ID
#
# Returns the security group that will be attached to the
# internet-facing Application Load Balancer.
##############################################################
output "alb_security_group_id" {
  description = "Unique identifier of the ALB security group."
  value       = module.security_groups.alb_security_group_id
}

##############################################################
# EC2 Web Security Group ID
#
# Returns the security group that will protect private EC2 web
# application instances.
##############################################################
output "web_security_group_id" {
  description = "Unique identifier of the EC2 web-tier security group."
  value       = module.security_groups.web_security_group_id
}

##############################################################
# RDS Security Group ID
#
# Returns the security group that will protect the private
# PostgreSQL database.
##############################################################
output "rds_security_group_id" {
  description = "Unique identifier of the Amazon RDS security group."
  value       = module.security_groups.rds_security_group_id
}

##############################################################
# VPC Endpoint Security Group ID
#
# Returns the security group that will protect future interface
# VPC endpoints.
##############################################################
output "vpce_security_group_id" {
  description = "Unique identifier of the VPC endpoint security group."
  value       = module.security_groups.vpce_security_group_id
}
