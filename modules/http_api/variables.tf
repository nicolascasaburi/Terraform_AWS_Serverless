#############################################
# Author: Casaburi, Nicolás Esteban
# API Gateway
#############################################

variable "name_prefix" {
  type        = string
  description = "Prefix for resources naming."
}

variable "api_name" {
  type        = string
  default     = "http-api"
  description = "Prefix for api naming."
}

variable "description" {
  type        = string
  default     = "HTTP API for Lambda-backed backend"
  description = "Description of API Gateway."
}

variable "lambda_invoke_arn" {
  type        = string
  description = "Lambda invocation ARN used to route HTTP requests to the lambda function."
}

variable "lambda_function_name" {
  type        = string
  description = "Lambda function name used to attach a resource-based permission that allows API Gateway to invoke the function"
}

variable "routes" {
  type = map(bool)
  default = {
    "GET /health"   = true
    "ANY /{proxy+}" = true
  }
  description = "Allowed routes in API Gateway"
}

variable "cors_enabled" {
  type        = bool
  default     = true
  description = "Enable CORS (Cross Origin Resource Share)"
}

variable "cors_allow_origins" {
  type        = list(string)
  default     = ["*"]
  description = "Allowed CORS origins"
}

variable "cors_allow_methods" {
  type        = list(string)
  default     = ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]
  description = "Allowed CORS methods"
}

variable "cors_allow_headers" {
  type        = list(string)
  default     = ["content-type", "authorization"]
  description = "Allowed CORS headers"
}

variable "stage_name" {
  type        = string
  default     = "$default"
  description = "Stage name of the API Gateway"
}

variable "auto_deploy" {
  type        = bool
  default     = true
  description = "Enable deploying API Gateway changes automatically"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to IAM resources."
}
