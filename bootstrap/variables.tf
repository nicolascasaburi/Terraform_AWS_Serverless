#############################################
# Author: Casaburi, Nicolás Esteban
# Bootstrap variables
#############################################

variable "region" {
  type        = string
  default     = "us-east-2"
  description = "AWS region where the bucket will be created."
}

variable "project" {
  type        = string
  default     = "aws-native-api"
  description = "Short project identifier used for naming and tagging"
}

variable "tags" {
  type = map(string)
  default = {
    ManagedBy = "Terraform"
    Purpose   = "tfstate"
  }
  description = "Tags applied to bootstrap resources."
}
