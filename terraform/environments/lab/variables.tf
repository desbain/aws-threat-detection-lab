variable "aws_region" {
  description = "AWS Region where the lab will be deployed"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Name used to identify project resources"
  type        = string
  default     = "aws-threat-detection-lab"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Resource owner tag"
  type        = string
  default     = "George-Awa"
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the lab VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "The VPC CIDR must be a valid IPv4 CIDR block."
  }
}

##############################################################
# Public Subnet A CIDR Block
#
# Defines the network range for the first public subnet.
#
# This subnet will be created in the first selected
# Availability Zone.
##############################################################
variable "public_subnet_a_cidr" {
  description = "CIDR block assigned to public subnet A."
  type        = string
  default     = "10.0.1.0/24"
}

##############################################################
# Public Subnet B CIDR Block
#
# Defines the network range for the second public subnet.
#
# This subnet will be created in a separate Availability Zone
# to support a resilient Application Load Balancer.
##############################################################
variable "public_subnet_b_cidr" {
  description = "CIDR block assigned to public subnet B."
  type        = string
  default     = "10.0.2.0/24"
}

##############################################################
# Private Subnet A CIDR Block
#
# Defines the network range for the first private subnet.
#
# Application and database resources placed here will not
# receive public IPv4 addresses automatically.
##############################################################
variable "private_subnet_a_cidr" {
  description = "CIDR block assigned to private subnet A."
  type        = string
  default     = "10.0.11.0/24"
}

##############################################################
# Private Subnet B CIDR Block
#
# Defines the network range for the second private subnet.
#
# This subnet provides a second Availability Zone for private
# application and database resources.
##############################################################
variable "private_subnet_b_cidr" {
  description = "CIDR block assigned to private subnet B."
  type        = string
  default     = "10.0.12.0/24"
}

##############################################################
# Availability Zone A
#
# Defines the first Availability Zone used for public subnet A
# and private subnet A.
##############################################################
variable "availability_zone_a" {
  description = "First Availability Zone used by the lab network."
  type        = string
  default     = "us-east-2a"
}

##############################################################
# Availability Zone B
#
# Defines the second Availability Zone used for public subnet B
# and private subnet B.
##############################################################
variable "availability_zone_b" {
  description = "Second Availability Zone used by the lab network."
  type        = string
  default     = "us-east-2b"
}
