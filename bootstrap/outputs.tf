#############################################
# Author: Casaburi, Nicolás Esteban
# Bootstrap outputs
#############################################

output "tfstate_bucket_name" {
  value       = aws_s3_bucket.tfstate.bucket
  description = "Name of the S3 bucket that will store Terraform state."
}

output "region" {
  value       = var.region
  description = "Region where the tfstate bucket was created."
}

output "backend_key" {
  value       = "state/dev/infra.tfstate"
  description = "Backend key."
}

output "backend_hcl_snippet" {
  value       = <<EOT
bucket       = "${aws_s3_bucket.tfstate.bucket}"
key          = "state/dev/infra.tfstate"
region       = "${var.region}"
encrypt      = true
use_lockfile = true
EOT
  description = "Snippet for backend.hcl."
}
