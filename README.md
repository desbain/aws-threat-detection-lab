# AWS Threat Detection and Log Correlation Lab

This project deploys an AWS environment for investigating a simulated malicious
event by correlating security telemetry from:

- Amazon GuardDuty
- AWS CloudTrail
- VPC Flow Logs
- Route 53 Resolver DNS query logs
- Application Load Balancer access logs
- Amazon RDS audit and database logs
- Amazon CloudWatch Logs
- Amazon Athena

## Project Objective

Deploy a vulnerable but controlled AWS web application environment, generate
authorized security-test telemetry, investigate the event, reconstruct the
timeline, identify indicators of compromise, map activity to MITRE ATT&CK, and
document containment and remediation actions.

## AWS Region

`us-east-2`

## Infrastructure Management

All AWS resources are managed with Terraform.

## Current Status

Phase 1: Core infrastructure deployment.

## Networking Status

The networking foundation is deployed in `us-east-2` and includes a custom VPC,
two public subnets, two private subnets, an Internet Gateway, one NAT Gateway,
public and private route tables, and Terraform remote state in Amazon S3.
