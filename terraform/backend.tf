terraform {
  backend "s3" {
    # The S3 bucket where Terraform will store the state file
    bucket = "citrux-dev-bucket" 
    
    # The path within the S3 bucket where the state file will be stored
    key    = "states/rest-api-aws-terraform/example/terraform.tfstate"
    
    # The AWS region where the S3 bucket is located
    region = "us-west-2"
    
    # The name of the DynamoDB table used for state locking
    dynamodb_table = "terraform-state-lock-dynamo-dev" 
    
    # DynamoDB is used to prevent concurrent operations on the state file
    # by locking it during Terraform runs. If you change the table name,
    # make sure to update this value to reflect the new table name.
  }
}
# terraform {
#   backend "s3" {
#     # The S3 bucket where Terraform will store the state file
#     bucket = "example-bucket"  # Replace with your actual bucket name
    
#     # The path within the S3 bucket where the state file will be stored
#     key    = "states/example-project/dev/terraform.tfstate"  # Replace with your actual key path
    
#     # The AWS region where the S3 bucket is located
#     region = "us-west-2"  # Replace with your actual region if different
    
#     # The name of the DynamoDB table used for state locking
#     dynamodb_table = "terraform-state-lock-table"  # Replace with your actual DynamoDB table name
    
#     # DynamoDB is used to prevent concurrent operations on the state file
#     # by locking it during Terraform runs. If you change the table name,
#     # make sure to update this value to reflect the new table name.
#   }
# }
