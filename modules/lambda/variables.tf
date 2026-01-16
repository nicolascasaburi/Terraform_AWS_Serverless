#############################################
# Author: Casaburi, Nicolás Esteban
# Lambda variables
#############################################

variable "name_prefix" {
  type        = string
  description = "Prefix for resources naming."
}

variable "lambda_name" {
  type        = string
  description = "Prefix for lambda naming."
}

variable "description" {
  type        = string
  default     = "Serverless application function."
  description = "Description of lambda function."
}

variable "runtime" {
  type        = string
  default     = "python3.12"
  description = "Lambda runtime identifier."
}

variable "handler" {
  type        = string
  default     = "app.handler"
  description = "Function that lambda invokes on each request."
}

variable "timeout_seconds" {
  type        = number
  default     = 10
  description = "Maximum execution time for a single invocation."
}

variable "memory_mb" {
  type        = number
  default     = 256
  description = "Memory allocated to the function."
}

variable "log_retention_days" {
  type        = number
  default     = 14
  description = "Number of days to retain CloudWatch Logs."
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "Map of environment variables injected into the function."
}

variable "package_path" {
  type        = string
  description = "Path to the lambda zip file."
}

variable "dynamodb_table_arn" {
  type        = string
  default     = null
  description = "ARN of a dynamodb table, used to give IAM permissions to a specific table."
}

variable "s3_bucket_arn" {
  type        = string
  default     = null
  description = "ARN of a S3 bucket, used to give IAM permissions to a specific bucket."
}

variable "attach_to_vpc" {
  type        = bool
  default     = false
  description = "Whether to attach the lambda function to a VPC."
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of subnet IDs used when attach_to_vpc is enabled."
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "List of security group IDs used when attach_to_vpc is enabled."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to IAM resources."
}
