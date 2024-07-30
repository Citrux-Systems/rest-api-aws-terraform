variable "users_lambda_invoke_arn" {
  description = "ARN of the Users Lambda function to be invoked by API Gateway"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}