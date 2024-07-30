# Define Variables for Terraform Configuration

# Variable for AWS region
variable "aws_region" {
  description = "AWS Region to deploy resources" # Description of the AWS region variable
  type        = string # Data type of the variable
  default     = "us-west-2" # Default value for the AWS region
}