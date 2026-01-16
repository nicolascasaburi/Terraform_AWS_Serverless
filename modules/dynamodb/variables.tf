#############################################
# Author: Casaburi, Nicolás Esteban
# DynamoDB variables
#############################################

variable "name_prefix" {
  type        = string
  description = "Prefix for resources naming"
}

variable "table-name" {
  type        = string
  description = "Prefix for table naming"
}

variable "billing_mode" {
  type        = string
  default     = "PAY_PER_REQUEST"
  description = "How capacity is billed"
  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "billing_mode must be PAY_PER_REQUEST or PROVISIONED"
  }
}

variable "hash_key" {
  type        = string
  description = "Partition Key"
}

variable "range_key" {
  type        = string
  default     = null
  description = "Sort Key"
}

variable "attributes" {
  type = list(object({
    name = string
    type = string
  }))
  description = "List of attributes used as keys and indexes, where type is S|N|B"
}

variable "ttl_attribute_name" {
  type        = string
  default     = null
  description = "Name of the attribute for TTL"
}

variable "enable_ttl" {
  type        = bool
  default     = false
  description = "Enable TTL"
}

variable "point_in_time_recovery" {
  type        = bool
  default     = true
  description = "Enable point in time recovery backups"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to IAM resources."
}
