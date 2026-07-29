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
