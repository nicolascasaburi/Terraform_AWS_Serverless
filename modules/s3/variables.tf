#############################################
# Author: Casaburi, Nicolás Esteban
# S3 (Simple Storage Service)
#############################################

variable "name_prefix" {
  type        = string
  description = "Prefix for resources naming."
}

variable "bucket_name" {
  type        = string
  description = "Base bucket name."
}

variable "use_random_suffix" {
  type        = bool
  default     = true
  description = "Enable a random suffix to reduce name collisions."
}

variable "versioning_enabled" {
  type        = bool
  default     = true
  description = "Enable versioning on S3."
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Enable destroying buckets even though they have objects."
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "Algorithm for server side encryption."
}

variable "lifecycle_enabled" {
  type        = bool
  default     = false
  description = "Enable lifecycle."
}

variable "lifecycle_expire_days" {
  type        = number
  default     = 30
  description = "Object expiration days."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to IAM resources."
}
