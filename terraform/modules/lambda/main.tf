# Purpose: Create the Lambda functions and their permissions.

# Create the Lambda function for users
resource "aws_lambda_function" "users" {
  function_name    = "usersExampleLambda"  # Name of the Lambda function
  filename         = "../dist/test-lambda.zip"  # Path to the deployment package
  source_code_hash = filebase64sha256("../dist/test-lambda.zip")  # Base64-encoded SHA256 hash of the deployment package
  handler          = "index.userHandler"  # The entry point to the Lambda function in the deployment package
  runtime          = "nodejs18.x"  # Runtime environment for the Lambda function

  role = aws_iam_role.lambda_exec.arn  # The ARN of the IAM role that Lambda assumes when it executes the function

  vpc_config {  # VPC configuration for the Lambda function
    subnet_ids         = var.subnets_ids  # List of VPC subnet IDs
    security_group_ids = [aws_security_group.lambda_sg.id]  # List of VPC security group IDs
  }

  environment {  # Environment variables for the Lambda function
    variables = {
      # Add environment variables here
    }
  }

  timeout = 900  # Set the timeout to 15 minutes
}

# Create the permissions for API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "apigw_users" {
  statement_id  = "AllowAPIGatewayInvoke"  # Identifier for the permission statement
  action        = "lambda:InvokeFunction"  # Action that this permission allows
  function_name = aws_lambda_function.users.function_name  # Name of the Lambda function
  principal     = "apigateway.amazonaws.com"  # The principal who is given permission to invoke the Lambda function
}

# Create an IAM role that the Lambda function will assume
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role_example"  # Name of the IAM role

  assume_role_policy = jsonencode({  # Policy that allows Lambda to assume this role
    Version   = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",  # Action that allows assuming the role
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"  # The service that will assume this role
        }
      }
    ]
  })
}

# Create an IAM policy that allows Lambda to log to CloudWatch Logs
resource "aws_iam_policy" "lambda_logging" {
  name        = "LambdaLoggingExample"  # Name of the IAM policy
  description = "Allow Lambda to log to CloudWatch Logs"  # Description of the IAM policy

  policy = jsonencode({  # Policy document
    Version   = "2012-10-17",
    Statement = [
      {
        Action = [  # Actions allowed by this policy
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"  # Apply this policy to all resources
      }
    ]
  })
}

# Attach the logging policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_exec.name  # Name of the IAM role
  policy_arn = aws_iam_policy.lambda_logging.arn  # ARN of the logging policy
}

# Create an IAM policy that allows Lambda to manage ENIs for VPC access
resource "aws_iam_policy" "lambda_vpc_access" {
  name        = "LambdaVPCAccessExample"  # Name of the IAM policy
  description = "Allow Lambda to manage ENIs for VPC access"  # Description of the IAM policy

  policy = jsonencode({  # Policy document
    Version   = "2012-10-17",
    Statement = [
      {
        Action = [  # Actions allowed by this policy
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Effect   = "Allow",
        Resource = "*"  # Apply this policy to all resources
      }
    ]
  })
}

# Attach the VPC access policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_vpc_access_attachment" {
  role       = aws_iam_role.lambda_exec.name  # Name of the IAM role
  policy_arn = aws_iam_policy.lambda_vpc_access.arn  # ARN of the VPC access policy
}

# Create a security group for the Lambda function
resource "aws_security_group" "lambda_sg" {
  vpc_id = var.lambda_vpc_id  # VPC ID where the security group will be created
  name   = "lambda_sg_example"  # Name of the security group

  egress {  # Egress rules for the security group
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  ingress {  # Ingress rules for the security group
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all inbound traffic
  }
}
