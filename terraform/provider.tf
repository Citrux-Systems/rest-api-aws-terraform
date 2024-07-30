# Define Terraform Providers
terraform {
  # Specify required providers and their versions
  required_providers {
    aws = {
      source = "hashicorp/aws" # Source of the AWS provider
    }
  }
  required_version = ">= 0.13" # Minimum Terraform version required
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region # AWS region where resources will be deployed
}
