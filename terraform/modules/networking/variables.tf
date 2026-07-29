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

##############################################################
# Availability Zone A
#
# Defines the first Availability Zone used by the networking
# module.
#
# Public subnet A and private subnet A are placed in this zone.
#
# Explicitly providing the zone makes local development and
# GitHub Actions produce the same network layout.
##############################################################
variable "availability_zone_a" {
  description = "First Availability Zone used by the networking module."
  type        = string

  validation {
    condition     = length(var.availability_zone_a) > 0
    error_message = "Availability Zone A cannot be empty."
  }
}

##############################################################
# Availability Zone B
#
# Defines the second Availability Zone used by the networking
# module.
#
# Public subnet B and private subnet B are placed in this zone
# to distribute resources across a separate failure domain.
##############################################################
variable "availability_zone_b" {
  description = "Second Availability Zone used by the networking module."
  type        = string

  validation {
    condition     = length(var.availability_zone_b) > 0
    error_message = "Availability Zone B cannot be empty."
  }
}
