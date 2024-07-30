# Define Terraform Modules

# VPC Module
module "vpc" {
  source = "./modules/vpc" # Path to the VPC module source
}

# API Gateway Module
module "api-gateway" {
  source                               = "./modules/api-gateway" # Path to the API Gateway module source
  users_lambda_invoke_arn              = module.lambda.user_lambda_arn # ARN for user Lambda invocation
  aws_region                           = var.aws_region # AWS region for deployment
}

# Lambda Module
module "lambda" {
  source                          = "./modules/lambda" # Path to the Lambda module source
  subnets_ids                     = module.vpc.subnets_ids # IDs of subnets from the VPC module
  lambda_vpc_id                   = module.vpc.lambda_vpc_id # VPC ID for Lambda functions
}
