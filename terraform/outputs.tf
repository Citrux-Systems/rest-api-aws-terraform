# Define an Output for Terraform Configuration

output "api_gateway_invoke_url" {
  value = module.api-gateway.url # API Gateway invoke URL
}