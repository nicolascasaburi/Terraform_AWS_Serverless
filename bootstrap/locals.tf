#############################################
# Author: Casaburi, Nicolás Esteban
# Bootstrap locals
#############################################

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_id" "suffix" {
  byte_length = 3 # 6 hex chars
}

locals {
  bucket_name = lower(
    "tfstate-${var.project}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-${random_id.suffix.hex}"
  )
}
