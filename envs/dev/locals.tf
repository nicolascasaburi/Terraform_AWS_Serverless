#############################################
# Author: Casaburi, Nicolás Esteban
# Environment Dev locals
#############################################

locals {
  name_prefix = "${var.project}-${var.env}"
  region      = "us-east-2"
}
