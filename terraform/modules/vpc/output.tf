// Output the ID of the VPC for Lambda
output "lambda_vpc_id" {
  description = "Lambda VPC ID"
  value       = aws_vpc.lambda_vpc.id
}

// Output the list of private subnet IDs for Lambda
output "subnets_ids" {
  description = "List of subnet IDs for Lambda"
  value       = [aws_subnet.lambda_subnet_a.id, aws_subnet.lambda_subnet_b.id]
}

// Output a single subnet ID for Lambda and RDS
output "subnet_id" {
  description = "Subnet ID for Lambda and RDS"
  value       = aws_subnet.lambda_subnet_a.id
}

// Output the ID of the default security group
output "security_group_primary_default_id" {
  description = "Security group ID for primary default"
  value       = aws_security_group.primary_default.id
}