##############################################################
# Project : AWS Threat Detection and Log Correlation Lab
# Module  : Networking
# File    : main.tf
#
# Purpose:
# This file creates the foundational AWS network used by the
# threat-detection lab.
#
# Resources created:
# - Custom VPC
# - Two public subnets
# - Two private subnets
# - Internet Gateway
# - Elastic IP address
# - NAT Gateway
# - Public route table
# - Private route table
# - Route table associations
##############################################################

##############################################################
# Threat Detection Lab VPC
#
# Creates the isolated network boundary for the entire lab.
#
# DNS support and DNS hostnames are enabled because EC2,
# Route 53 Resolver, Systems Manager, GuardDuty, and other AWS
# services rely on functioning DNS resolution.
##############################################################
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

##############################################################
# Internet Gateway
#
# Provides internet connectivity for resources placed in the
# public subnets.
#
# The public route table will send internet-bound traffic to
# this gateway.
##############################################################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

##############################################################
# Public Subnet A
#
# Creates the first public subnet in the first selected
# Availability Zone.
#
# Public IP assignment is enabled so eligible resources can
# receive public IPv4 addresses when launched in this subnet.
##############################################################
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.project_name}-${var.environment}-public-subnet-a"
    Tier                     = "Public"
    "kubernetes.io/role/elb" = "1"
  }
}

##############################################################
# Public Subnet B
#
# Creates the second public subnet in a separate Availability
# Zone.
#
# The Application Load Balancer will use both public subnets
# for resilient ingress traffic handling.
##############################################################
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.project_name}-${var.environment}-public-subnet-b"
    Tier                     = "Public"
    "kubernetes.io/role/elb" = "1"
  }
}

##############################################################
# Private Subnet A
#
# Creates the first private subnet in the first selected
# Availability Zone.
#
# Automatic public IPv4 assignment is disabled to prevent
# workloads from receiving direct public exposure.
##############################################################
resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_a_cidr
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = false

  tags = {
    Name                              = "${var.project_name}-${var.environment}-private-subnet-a"
    Tier                              = "Private"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

##############################################################
# Private Subnet B
#
# Creates the second private subnet in a separate Availability
# Zone.
#
# This subnet supports resilient application and database
# deployment without direct internet exposure.
##############################################################
resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_b_cidr
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = false

  tags = {
    Name                              = "${var.project_name}-${var.environment}-private-subnet-b"
    Tier                              = "Private"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

##############################################################
# NAT Gateway Elastic IP Address
#
# Reserves a public IPv4 address for the NAT Gateway.
#
# The domain value identifies this address as a VPC-scoped
# Elastic IP address.
##############################################################
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-eip"
  }

  depends_on = [
    aws_internet_gateway.this
  ]
}

##############################################################
# NAT Gateway
#
# Provides controlled outbound internet access for resources
# located in the private subnets.
#
# Private instances can download packages and reach supported
# AWS public endpoints without accepting unsolicited inbound
# connections from the internet.
#
# A single NAT Gateway is used to reduce lab costs. Production
# environments commonly deploy one NAT Gateway per
# Availability Zone for greater resilience.
##############################################################
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.this
  ]
}

##############################################################
# Public Route Table
#
# Controls routing for both public subnets.
#
# Internet-bound IPv4 traffic is sent to the Internet Gateway.
##############################################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-${var.environment}-public-route-table"
  }
}

##############################################################
# Public Default Route
#
# Sends all non-local IPv4 traffic from the public subnets to
# the Internet Gateway.
##############################################################
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

##############################################################
# Public Subnet A Route Table Association
#
# Associates public subnet A with the public route table.
##############################################################
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

##############################################################
# Public Subnet B Route Table Association
#
# Associates public subnet B with the public route table.
##############################################################
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

##############################################################
# Private Route Table
#
# Controls routing for both private subnets.
#
# Internet-bound traffic is sent through the NAT Gateway rather
# than directly through the Internet Gateway.
##############################################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-${var.environment}-private-route-table"
  }
}

##############################################################
# Private Default Route
#
# Sends internet-bound IPv4 traffic from the private subnets
# through the NAT Gateway.
#
# This allows outbound connections while preserving the private
# subnets' lack of direct inbound internet routing.
##############################################################
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

##############################################################
# Private Subnet A Route Table Association
#
# Associates private subnet A with the private route table.
##############################################################
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

##############################################################
# Private Subnet B Route Table Association
#
# Associates private subnet B with the private route table.
##############################################################
resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}
