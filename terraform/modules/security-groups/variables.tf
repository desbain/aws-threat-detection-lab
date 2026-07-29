##############################################################
# Project : AWS Threat Detection and Log Correlation Lab
# Module  : Security Groups
# File    : variables.tf
#
# Purpose:
# Defines the configurable values used to create security
# groups for the Application Load Balancer, EC2 web tier,
# Amazon RDS database, and VPC interface endpoints.
##############################################################

##############################################################
# Project Name
#
# Provides a consistent naming prefix for all security groups.
#
# Example:
# aws-threat-detection-lab
##############################################################
variable "project_name" {
  description = "Project name used as a naming prefix for security groups."
  type        = string
}

##############################################################
# Environment Name
#
# Identifies the deployment environment associated with the
# security groups.
#
# Example:
# lab
##############################################################
variable "environment" {
  description = "Deployment environment associated with the security groups."
  type        = string
}

##############################################################
# VPC ID
#
# Identifies the VPC where the security groups will be created.
#
# This value is provided by the networking module.
##############################################################
variable "vpc_id" {
  description = "Unique identifier of the VPC where security groups are created."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "The VPC ID must use a valid AWS VPC identifier format."
  }
}

##############################################################
# Application Listener Port
#
# Defines the HTTP port accepted by the Application Load
# Balancer and forwarded to the EC2 web tier.
##############################################################
variable "web_port" {
  description = "TCP port used by the web application."
  type        = number
  default     = 80

  validation {
    condition     = var.web_port >= 1 && var.web_port <= 65535
    error_message = "The web port must be between 1 and 65535."
  }
}

##############################################################
# HTTPS Listener Port
#
# Defines the encrypted listener port exposed by the
# Application Load Balancer.
##############################################################
variable "https_port" {
  description = "TCP port used for HTTPS traffic."
  type        = number
  default     = 443

  validation {
    condition     = var.https_port >= 1 && var.https_port <= 65535
    error_message = "The HTTPS port must be between 1 and 65535."
  }
}

##############################################################
# PostgreSQL Database Port
#
# Defines the database port allowed from the EC2 web tier to
# Amazon RDS.
##############################################################
variable "database_port" {
  description = "TCP port used by the PostgreSQL database."
  type        = number
  default     = 5432

  validation {
    condition     = var.database_port >= 1 && var.database_port <= 65535
    error_message = "The database port must be between 1 and 65535."
  }
}

##############################################################
# Internet IPv4 CIDR Block
#
# Defines the IPv4 source allowed to reach the public ALB.
#
# The default permits internet clients to access the lab's
# HTTP and HTTPS listeners.
##############################################################
variable "internet_ipv4_cidr" {
  description = "IPv4 CIDR block permitted to access the public ALB."
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrnetmask(var.internet_ipv4_cidr))
    error_message = "The internet IPv4 source must be a valid CIDR block."
  }
}

##############################################################
# Resource Tags
#
# Provides optional resource-specific tags in addition to the
# default tags configured by the AWS provider.
##############################################################
variable "additional_tags" {
  description = "Additional tags applied to security-group resources."
  type        = map(string)
  default     = {}
}
