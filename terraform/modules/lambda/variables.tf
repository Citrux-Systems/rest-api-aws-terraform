// Variable Definitions

// List of subnet IDs for the Lambda VPC
variable "subnets_ids" {
  description = "List of subnet IDs for the Lambda VPC"
  type        = list(string)
}

// VPC ID for the Lambda function
variable "lambda_vpc_id" {
  description = "VPC ID for the Lambda function"
  type        = string
}