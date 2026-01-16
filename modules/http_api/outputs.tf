#############################################
# Author: Casaburi, Nicolás Esteban
# API Gateway
#############################################

output "api_id" {
  value       = aws_apigatewayv2_api.this.id
  description = "API Gateway id"
}

output "api_endpoint" {
  value       = aws_apigatewayv2_api.this.api_endpoint
  description = "API URL"
}

output "execution_arn" {
  value       = aws_apigatewayv2_api.this.execution_arn
  description = "Execution ARN of the API, used to restrict permissions"
}
