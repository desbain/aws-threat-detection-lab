##############################################################
# Project : AWS Threat Detection and Log Correlation Lab
# Module  : Networking
# File    : outputs.tf
#
# Purpose:
# This file exposes networking resource identifiers and
# attributes for use by the EC2, ALB, RDS, logging, and
# security modules.
##############################################################

##############################################################
# VPC ID
#
# Returns the unique identifier of the threat detection lab VPC.
#
# Other modules use this value to create resources inside the
# correct network.
##############################################################
output "vpc_id" {
  description = "Unique identifier of the threat detection lab VPC."
  value       = aws_vpc.this.id
}

##############################################################
# VPC CIDR Block
#
# Returns the IPv4 address range assigned to the VPC.
#
# Security group modules can use this value when defining
# trusted internal network rules.
##############################################################
output "vpc_cidr_block" {
  description = "IPv4 CIDR block assigned to the threat detection lab VPC."
  value       = aws_vpc.this.cidr_block
}

##############################################################
# Public Subnet IDs
#
# Returns both public subnet identifiers as a list.
#
# The Application Load Balancer module will use these subnets
# to provide internet-facing service across two Availability
# Zones.
##############################################################
output "public_subnet_ids" {
  description = "List containing the two public subnet identifiers."
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

##############################################################
# Private Subnet IDs
#
# Returns both private subnet identifiers as a list.
#
# EC2 and RDS modules will use these subnets to keep application
# and database resources away from direct internet exposure.
##############################################################
output "private_subnet_ids" {
  description = "List containing the two private subnet identifiers."
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

##############################################################
# Public Subnet A ID
#
# Returns the identifier of public subnet A.
##############################################################
output "public_subnet_a_id" {
  description = "Unique identifier of public subnet A."
  value       = aws_subnet.public_a.id
}

##############################################################
# Public Subnet B ID
#
# Returns the identifier of public subnet B.
##############################################################
output "public_subnet_b_id" {
  description = "Unique identifier of public subnet B."
  value       = aws_subnet.public_b.id
}

##############################################################
# Private Subnet A ID
#
# Returns the identifier of private subnet A.
##############################################################
output "private_subnet_a_id" {
  description = "Unique identifier of private subnet A."
  value       = aws_subnet.private_a.id
}

##############################################################
# Private Subnet B ID
#
# Returns the identifier of private subnet B.
##############################################################
output "private_subnet_b_id" {
  description = "Unique identifier of private subnet B."
  value       = aws_subnet.private_b.id
}

##############################################################
# Internet Gateway ID
#
# Returns the identifier of the Internet Gateway attached to
# the VPC.
##############################################################
output "internet_gateway_id" {
  description = "Unique identifier of the VPC Internet Gateway."
  value       = aws_internet_gateway.this.id
}

##############################################################
# NAT Gateway ID
#
# Returns the identifier of the NAT Gateway used by the private
# subnet route table.
##############################################################
output "nat_gateway_id" {
  description = "Unique identifier of the NAT Gateway."
  value       = aws_nat_gateway.this.id
}

##############################################################
# Public Route Table ID
#
# Returns the identifier of the route table associated with
# both public subnets.
##############################################################
output "public_route_table_id" {
  description = "Unique identifier of the public route table."
  value       = aws_route_table.public.id
}

##############################################################
# Private Route Table ID
#
# Returns the identifier of the route table associated with
# both private subnets.
##############################################################
output "private_route_table_id" {
  description = "Unique identifier of the private route table."
  value       = aws_route_table.private.id
}

##############################################################
# Availability Zones
#
# Returns the two Availability Zones configured for the lab.
#
# This output documents how the public and private subnets are
# distributed across separate AWS failure domains.
##############################################################
output "availability_zones" {
  description = "Availability Zones used by the lab network."

  value = [
    var.availability_zone_a,
    var.availability_zone_b
  ]
}
