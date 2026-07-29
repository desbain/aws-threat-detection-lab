##############################################################
# Project : AWS Threat Detection and Log Correlation Lab
# Module  : Networking
# File    : variables.tf
#
# Purpose:
# This file defines the configurable values used to create
# the VPC, subnets, Internet Gateway, NAT Gateway, route
# tables, and subnet routing associations.
##############################################################

##############################################################
# Project Name
#
# Provides a consistent naming prefix for networking resources.
#
# Example:
# aws-threat-detection-lab
##############################################################
variable "project_name" {
  description = "Project name used as a naming prefix for AWS resources."
  type        = string
}

##############################################################
# Environment Name
#
# Identifies the deployment environment associated with the
# networking resources.
#
# Example:
# lab
##############################################################
variable "environment" {
  description = "Deployment environment associated with the networking resources."
  type        = string
}

##############################################################
# VPC CIDR Block
#
# Defines the private IPv4 address range assigned to the VPC.
#
# The /16 range provides sufficient address space for the
# public and private subnets used by the lab.
##############################################################
variable "vpc_cidr" {
  description = "IPv4 CIDR block assigned to the threat detection lab VPC."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "The VPC CIDR must be a valid IPv4 CIDR block."
  }
}

##############################################################
# Public Subnet A CIDR Block
#
# Defines the IPv4 address range for the first public subnet.
#
# This subnet will host public-facing resources such as the
# Application Load Balancer and the NAT Gateway.
##############################################################
variable "public_subnet_a_cidr" {
  description = "IPv4 CIDR block assigned to public subnet A."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.public_subnet_a_cidr))
    error_message = "Public subnet A must use a valid IPv4 CIDR block."
  }
}

##############################################################
# Public Subnet B CIDR Block
#
# Defines the IPv4 address range for the second public subnet.
#
# The second subnet allows the Application Load Balancer to
# operate across two Availability Zones.
##############################################################
variable "public_subnet_b_cidr" {
  description = "IPv4 CIDR block assigned to public subnet B."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.public_subnet_b_cidr))
    error_message = "Public subnet B must use a valid IPv4 CIDR block."
  }
}

##############################################################
# Private Subnet A CIDR Block
#
# Defines the IPv4 address range for the first private subnet.
#
# Private workloads such as EC2 application servers and RDS
# database resources can be placed in this subnet.
##############################################################
variable "private_subnet_a_cidr" {
  description = "IPv4 CIDR block assigned to private subnet A."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.private_subnet_a_cidr))
    error_message = "Private subnet A must use a valid IPv4 CIDR block."
  }
}

##############################################################
# Private Subnet B CIDR Block
#
# Defines the IPv4 address range for the second private subnet.
#
# The second private subnet supports multi-Availability-Zone
# architecture for the web and database tiers.
##############################################################
variable "private_subnet_b_cidr" {
  description = "IPv4 CIDR block assigned to private subnet B."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.private_subnet_b_cidr))
    error_message = "Private subnet B must use a valid IPv4 CIDR block."
  }
}
