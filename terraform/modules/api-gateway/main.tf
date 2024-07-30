# Create an IAM role for API Gateway to push logs to CloudWatch
resource "aws_iam_role" "api_gateway_cloudwatch_role" {
  name = "api-gateway-example-cloudwatch-role"  # Name of the IAM role

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",  # Allow API Gateway to assume this role
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"  # The service that will assume this role
        }
      }
    ]
  })
}

# Attach the necessary policy to the IAM role to allow API Gateway to push logs to CloudWatch
resource "aws_iam_role_policy_attachment" "api_gateway_cloudwatch_role_policy" {
  role       = aws_iam_role.api_gateway_cloudwatch_role.name  # The IAM role created above
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"  # The managed policy that grants the necessary permissions
}

# Configure the API Gateway account to use the IAM role for pushing logs to CloudWatch
resource "aws_api_gateway_account" "api_gw_account" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch_role.arn  # The ARN of the IAM role created above
}

# Create a CloudWatch log group for API Gateway logs
resource "aws_cloudwatch_log_group" "api_logs" {
  name = "/aws/api_gateway/example-api"  # Name of the log group
}

# Create an API Gateway REST API
resource "aws_api_gateway_rest_api" "api" {
  name               = "example-api"  # Name of the API Gateway
  binary_media_types = ["multipart/form-data"]  # List of binary media types supported by the API
  description        = "Example API Gateway"  # Description of the API Gateway
  body               = templatefile("./templates/swagger.yaml", {  # Load the Swagger definition from a template file
    userLambdaArn = var.users_lambda_invoke_arn  # Placeholder for a Lambda function ARN
    cognito_user_pool_arn = aws_cognito_user_pool.main.arn 
  })
}

# Deploy the API Gateway REST API
resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id  # The ID of the REST API to deploy

  triggers = {
    redeployment = sha256(file("./templates/swagger.yaml"))  # Redeploy if the Swagger definition changes
  }

  lifecycle {
    create_before_destroy = true  # Ensure a new deployment is created before the old one is destroyed
  }
}

# Create a stage for the API Gateway REST API
resource "aws_api_gateway_stage" "api_gateway_stage" {
  deployment_id = aws_api_gateway_deployment.api.id  # The ID of the deployment
  rest_api_id   = aws_api_gateway_rest_api.api.id  # The ID of the REST API
  stage_name    = "dev-example"  # Name of the stage

  # Configure access logging for the stage
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn  # The ARN of the CloudWatch log group
    format          = "{ \"requestId\":\"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"caller\":\"$context.identity.caller\", \"user\":\"$context.identity.user\", \"requestTime\":\"$context.requestTime\", \"httpMethod\":\"$context.httpMethod\", \"resourcePath\":\"$context.resourcePath\", \"status\":\"$context.status\", \"protocol\":\"$context.protocol\", \"responseLength\":\"$context.responseLength\" }"  # Log format
  }

  xray_tracing_enabled = true  # Enable X-Ray tracing
}

# Configure method settings for the API Gateway stage
resource "aws_api_gateway_method_settings" "method_settings" {
  rest_api_id = aws_api_gateway_rest_api.api.id  # The ID of the REST API
  stage_name  = aws_api_gateway_stage.api_gateway_stage.stage_name  # The name of the stage
  method_path = "*/*"  # Apply these settings to all methods

  settings {
    metrics_enabled = true  # Enable CloudWatch metrics
    logging_level   = "INFO"  # Set logging level to INFO
  }
}


# Define a Cognito User Pool
resource "aws_cognito_user_pool" "main" {
  name = "example_user_pool"
  auto_verified_attributes = ["email"]

  // Set up the email configuration
  email_configuration {
    // Choose either COGNITO_DEFAULT or DEVELOPER to send via SES
    email_sending_account = "COGNITO_DEFAULT"
  }

  // ... additional configurations for the user pool ...
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "example-pool-domain"  # Replace with your desired domain prefix
  user_pool_id = aws_cognito_user_pool.main.id
}

# Define a Cognito User Pool Client
resource "aws_cognito_user_pool_client" "main" {
  name         = "example_pool_client"
  user_pool_id = aws_cognito_user_pool.main.id

  access_token_validity  = 1  // 1 hour
  id_token_validity      = 1  // 1 hour
  refresh_token_validity = 1 // 1 day

  // ... additional configurations for the user pool client ...
}

# Define the Cognito User Pool Authorizer for the API Gateway
resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name                             = "cognito_authorizer_example"
  rest_api_id                      = aws_api_gateway_rest_api.api.id
  type                             = "COGNITO_USER_POOLS"
  provider_arns                    = [aws_cognito_user_pool.main.arn]
  identity_source                  = "method.request.header.Authorization"
}