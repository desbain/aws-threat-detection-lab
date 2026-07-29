##############################################################
# Project : AWS Threat Detection and Log Correlation Lab
# Module  : Security Groups
# File    : outputs.tf
#
# Purpose:
# Exposes security-group identifiers for downstream ALB, EC2,
# RDS, and VPC endpoint modules.
##############################################################

##############################################################
# ALB Security Group ID
#
# Used by the Application Load Balancer module.
##############################################################
output "alb_security_group_id" {
  description = "Unique identifier of the Application Load Balancer security group."
  value       = aws_security_group.alb.id
}

##############################################################
# EC2 Web Security Group ID
#
# Used by EC2 instances and launch templates in the private web
# tier.
##############################################################
output "web_security_group_id" {
  description = "Unique identifier of the EC2 web-tier security group."
  value       = aws_security_group.web.id
}

##############################################################
# RDS Security Group ID
#
# Used by the Amazon RDS database instance or cluster.
##############################################################
output "rds_security_group_id" {
  description = "Unique identifier of the Amazon RDS security group."
  value       = aws_security_group.rds.id
}

##############################################################
# VPC Endpoint Security Group ID
#
# Used by future Systems Manager and CloudWatch interface
# endpoint resources.
##############################################################
output "vpce_security_group_id" {
  description = "Unique identifier of the VPC interface endpoint security group."
  value       = aws_security_group.vpce.id
}

##############################################################
# Security Group IDs
#
# Returns all security-group identifiers in a named map for
# convenient inspection and future module integration.
##############################################################
output "security_group_ids" {
  description = "Map of security-group names to their AWS identifiers."

  value = {
    alb  = aws_security_group.alb.id
    web  = aws_security_group.web.id
    rds  = aws_security_group.rds.id
    vpce = aws_security_group.vpce.id
  }
}
