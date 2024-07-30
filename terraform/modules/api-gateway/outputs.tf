# Output the URL of the API Gateway
output "url" {
  description = "URL of the API Gateway"  # Description of the output
  value       = "${aws_api_gateway_rest_api.api.execution_arn}/dev/"  # The value to output, in this case, the execution ARN of the API Gateway with the "dev" stage
}
