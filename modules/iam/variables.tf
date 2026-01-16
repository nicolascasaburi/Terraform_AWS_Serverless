#############################################
# Author: Casaburi, Nicolás Esteban
# IAM variables
#############################################

variable "name_prefix" {
  type        = string
  description = "Prefix for resources naming."
}

variable "role_name" {
  type        = string
  default     = "lambda-exec"
  description = "Name for the role."
}

variable "enable_cloudwatch_logs" {
  type        = bool
  default     = true
  description = "Enable Lambda to create and write log events in CloudWatch Logs."
}

variable "dynamodb_table_arn" {
  type        = string
  default     = null
  description = "DynamoDB table ARN that Lambda is allowed to access."
}

variable "dynamodb_access_mode" {
  type        = string
  default     = "readwrite"
  description = "DynamoDB access level: read, write, or readwrite."
  validation {
    condition     = contains(["read", "write", "readwrite"], var.dynamodb_access_mode)
    error_message = "dynamodb_access_mode must be: read, write, readwrite."
  }
}

variable "s3_bucket_arn" {
  type        = string
  default     = null
  description = "S3 bucket ARN that Lambda is allowed to access."
}

variable "s3_access_mode" {
  type        = string
  default     = "readwrite"
  description = "S3 access level: read, write, or readwrite."
  validation {
    condition     = contains(["read", "write", "readwrite"], var.s3_access_mode)
    error_message = "s3_access_mode must be: read, write, readwrite."
  }
}

variable "enable_vpc_access" {
  type        = bool
  default     = false
  description = "Enable attaching the AWS managed policy for Lambda VPC access."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to IAM resources."
}
