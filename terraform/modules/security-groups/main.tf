##############################################################
# Project : AWS Threat Detection and Log Correlation Lab
# Module  : Security Groups
# File    : main.tf
#
# Purpose:
# Creates least-privilege security groups for the ALB, EC2 web
# tier, Amazon RDS database, and VPC interface endpoints.
#
# Traffic flow:
# Internet -> ALB -> EC2 Web Tier -> RDS
#
# Administrative access:
# AWS Systems Manager Session Manager will be used instead of
# exposing SSH to the internet.
##############################################################

##############################################################
# Application Load Balancer Security Group
#
# Purpose:
# Protects the internet-facing Application Load Balancer.
#
# Inbound access is limited to HTTP and HTTPS from the
# configured public IPv4 CIDR block.
#
# The ALB is the only resource in the architecture intended to
# receive direct internet traffic.
##############################################################
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Controls inbound and outbound traffic for the public ALB."
  vpc_id      = var.vpc_id

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.project_name}-${var.environment}-alb-sg"
      Tier = "LoadBalancer"
    }
  )
}

##############################################################
# ALB HTTP Ingress Rule
#
# Allows public HTTP traffic to reach the Application Load
# Balancer on the configured web port.
#
# Later, HTTP can be redirected to HTTPS at the listener level.
##############################################################
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow public HTTP traffic to the Application Load Balancer."

  cidr_ipv4   = var.internet_ipv4_cidr
  from_port   = var.web_port
  ip_protocol = "tcp"
  to_port     = var.web_port
}

##############################################################
# ALB HTTPS Ingress Rule
#
# Allows encrypted HTTPS traffic from internet clients to the
# Application Load Balancer.
##############################################################
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow public HTTPS traffic to the Application Load Balancer."

  cidr_ipv4   = var.internet_ipv4_cidr
  from_port   = var.https_port
  ip_protocol = "tcp"
  to_port     = var.https_port
}

##############################################################
# ALB Egress to EC2 Web Tier
#
# Allows the Application Load Balancer to send HTTP requests
# only to resources associated with the EC2 web security group.
#
# Referencing the destination security group is safer than
# permitting traffic to an entire subnet CIDR range.
##############################################################
resource "aws_vpc_security_group_egress_rule" "alb_to_web" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow the ALB to forward HTTP traffic to the EC2 web tier."

  referenced_security_group_id = aws_security_group.web.id
  from_port                    = var.web_port
  ip_protocol                  = "tcp"
  to_port                      = var.web_port
}

##############################################################
# EC2 Web Tier Security Group
#
# Purpose:
# Protects application servers deployed in private subnets.
#
# The web tier does not accept direct internet traffic and does
# not expose SSH. Administrative access will use AWS Systems
# Manager Session Manager.
##############################################################
resource "aws_security_group" "web" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "Controls traffic for private EC2 web application instances."
  vpc_id      = var.vpc_id

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.project_name}-${var.environment}-web-sg"
      Tier = "Application"
    }
  )
}

##############################################################
# EC2 Web Ingress from ALB
#
# Allows web traffic only when the source is a resource using
# the ALB security group.
#
# Direct internet access to the EC2 application servers is not
# permitted.
##############################################################
resource "aws_vpc_security_group_ingress_rule" "web_from_alb" {
  security_group_id = aws_security_group.web.id
  description       = "Allow HTTP traffic from the Application Load Balancer."

  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = var.web_port
  ip_protocol                  = "tcp"
  to_port                      = var.web_port
}

##############################################################
# EC2 Web Egress to RDS
#
# Allows application servers to connect to the database only
# on the configured PostgreSQL port.
##############################################################
resource "aws_vpc_security_group_egress_rule" "web_to_rds" {
  security_group_id = aws_security_group.web.id
  description       = "Allow PostgreSQL traffic from the web tier to Amazon RDS."

  referenced_security_group_id = aws_security_group.rds.id
  from_port                    = var.database_port
  ip_protocol                  = "tcp"
  to_port                      = var.database_port
}

##############################################################
# EC2 Web HTTPS Egress
#
# Allows the EC2 web tier to initiate HTTPS connections.
#
# This supports Systems Manager, package repositories,
# CloudWatch, and AWS service API calls through NAT or future
# VPC interface endpoints.
##############################################################
resource "aws_vpc_security_group_egress_rule" "web_https" {
  security_group_id = aws_security_group.web.id
  description       = "Allow HTTPS egress for AWS services and software updates."

  cidr_ipv4   = var.internet_ipv4_cidr
  from_port   = var.https_port
  ip_protocol = "tcp"
  to_port     = var.https_port
}

##############################################################
# EC2 Web DNS Egress over UDP
#
# Allows application instances to resolve DNS queries using
# the VPC Route 53 Resolver.
#
# DNS activity will later be captured through Route 53 Resolver
# query logging for the investigation phase.
##############################################################
resource "aws_vpc_security_group_egress_rule" "web_dns_udp" {
  security_group_id = aws_security_group.web.id
  description       = "Allow outbound DNS queries over UDP."

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 53
  ip_protocol = "udp"
  to_port     = 53
}

##############################################################
# EC2 Web DNS Egress over TCP
#
# Allows DNS queries that require TCP, including larger DNS
# responses and protocol fallback.
##############################################################
resource "aws_vpc_security_group_egress_rule" "web_dns_tcp" {
  security_group_id = aws_security_group.web.id
  description       = "Allow outbound DNS queries over TCP."

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 53
  ip_protocol = "tcp"
  to_port     = 53
}

##############################################################
# Amazon RDS Security Group
#
# Purpose:
# Protects the private PostgreSQL database.
#
# The database is not reachable from the internet or directly
# from the ALB. Only the EC2 web tier can initiate database
# sessions.
##############################################################
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Controls inbound traffic to the private Amazon RDS database."
  vpc_id      = var.vpc_id

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.project_name}-${var.environment}-rds-sg"
      Tier = "Database"
    }
  )
}

##############################################################
# RDS Ingress from EC2 Web Tier
#
# Allows PostgreSQL sessions only from resources associated
# with the EC2 web security group.
##############################################################
resource "aws_vpc_security_group_ingress_rule" "rds_from_web" {
  security_group_id = aws_security_group.rds.id
  description       = "Allow PostgreSQL traffic from the EC2 web tier."

  referenced_security_group_id = aws_security_group.web.id
  from_port                    = var.database_port
  ip_protocol                  = "tcp"
  to_port                      = var.database_port
}

##############################################################
# VPC Endpoint Security Group
#
# Purpose:
# Protects future interface VPC endpoints used by Systems
# Manager, EC2 Messages, SSM Messages, and CloudWatch Logs.
#
# Interface endpoints accept HTTPS from private EC2 instances
# without requiring public internet access.
##############################################################
resource "aws_security_group" "vpce" {
  name        = "${var.project_name}-${var.environment}-vpce-sg"
  description = "Controls HTTPS access to interface VPC endpoints."
  vpc_id      = var.vpc_id

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.project_name}-${var.environment}-vpce-sg"
      Tier = "PrivateEndpoint"
    }
  )
}

##############################################################
# VPC Endpoint HTTPS Ingress
#
# Allows private EC2 instances to establish TLS sessions with
# future interface endpoints.
##############################################################
resource "aws_vpc_security_group_ingress_rule" "vpce_https_from_web" {
  security_group_id = aws_security_group.vpce.id
  description       = "Allow HTTPS traffic from the EC2 web tier to VPC endpoints."

  referenced_security_group_id = aws_security_group.web.id
  from_port                    = var.https_port
  ip_protocol                  = "tcp"
  to_port                      = var.https_port
}

##############################################################
# VPC Endpoint Egress
#
# Allows response traffic from interface endpoints.
#
# Security groups are stateful, but this explicit HTTPS egress
# rule documents the intended endpoint communication pattern.
##############################################################
resource "aws_vpc_security_group_egress_rule" "vpce_https" {
  security_group_id = aws_security_group.vpce.id
  description       = "Allow HTTPS egress from interface VPC endpoints."

  cidr_ipv4   = var.internet_ipv4_cidr
  from_port   = var.https_port
  ip_protocol = "tcp"
  to_port     = var.https_port
}
