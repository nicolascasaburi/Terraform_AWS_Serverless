#############################################
# Author: Casaburi, Nicolás Esteban
# DynamoDB
#############################################

output "function_name" {
  value       = aws_lambda_function.this.function_name
  description = "Lambda function name."
}

output "function_arn" {
  value       = aws_lambda_function.this.arn
  description = "Lambda arn."
}

output "invoke_arn" {
  value       = aws_lambda_function.this.invoke_arn
  description = "Lambda invocation ARN used by services to invoke the function."
}
