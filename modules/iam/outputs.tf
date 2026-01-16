#############################################
# Author: Casaburi, Nicolás Esteban
# IAM outputs
#############################################

output "role_name" {
  value       = aws_iam_role.this.name
  description = "Name of the IAM lambda execution role."
}

output "role_arn" {
  value       = aws_iam_role.this.arn
  description = "ARN of the IAM lambda execution role."
}
