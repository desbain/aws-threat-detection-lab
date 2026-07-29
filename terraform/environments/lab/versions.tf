##############################################################
# Project : AWS Threat Detection and Log Correlation Lab
# File    : versions.tf
#
# Purpose:
# Defines the Terraform CLI version and provider versions used
# by the project.
#
# Exact provider versions help ensure local Terraform runs and
# GitHub Actions use consistent dependencies.
##############################################################

terraform {
  ############################################################
  # Terraform CLI Version
  #
  # Requires Terraform 1.10.0 or newer.
  ############################################################
  required_version = ">= 1.10.0"

  ############################################################
  # Required Providers
  #
  # Defines the external providers Terraform must download.
  ############################################################
  required_providers {
    ##########################################################
    # AWS Provider
    #
    # Manages AWS networking, compute, logging, database, and
    # security resources used by the threat-detection lab.
    #
    # This exact version is pinned because AWS Provider 6.57.0
    # generated malformed EC2 API requests in the local
    # Windows and Git Bash environment.
    ##########################################################
    aws = {
      source  = "hashicorp/aws"
      version = "6.49.0"
    }

    ##########################################################
    # Random Provider
    #
    # Generates a stable suffix for resources that require
    # globally unique names, such as Amazon S3 buckets.
    ##########################################################
    random = {
      source  = "hashicorp/random"
      version = "3.9.0"
    }
  }
}
