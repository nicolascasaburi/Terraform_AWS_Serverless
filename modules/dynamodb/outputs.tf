#############################################
# Author: Casaburi, Nicolás Esteban
# DynamoDB
#############################################

output "table_name" {
  value       = aws_dynamodb_table.this.name
  description = "Table name of DynamoDB."
}

output "table_arn" {
  value       = aws_dynamodb_table.this.arn
  description = "ARN for DynamoDB."
}
