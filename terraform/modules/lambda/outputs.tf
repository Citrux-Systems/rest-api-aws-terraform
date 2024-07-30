# Output the ARN of the Lambda function for users
output "user_lambda_arn" {
  description = "ARN of the Lambda function for users"  # Description of the output
  value       = aws_lambda_function.users.arn  # The value to output, in this case, the ARN of the Lambda function
}
