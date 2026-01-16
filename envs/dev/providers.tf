#############################################
# Author: Casaburi, Nicolás Esteban
# Environment Dev providers
#############################################

# -----------------------------
# Provider AWS
# -----------------------------

provider "aws" {
  region = local.region
  default_tags {
    tags = {
      Project     = var.project
      Environment = var.env
      ManagedBy   = "Terraform"
    }
  }
}
