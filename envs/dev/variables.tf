#############################################
# Author: Casaburi, Nicolás Esteban
# Environment Dev variables
#############################################

variable "project" {
  type        = string
  default     = "terraform-aws-serverless"
  description = "Short project identifier used for naming and tagging"
}

variable "env" {
  type        = string
  default     = "dev"
  description = "Deployment environment used to drive naming and tagging."
}
