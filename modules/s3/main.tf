#############################################
# Author: Casaburi, Nicolás Esteban
# S3 (Simple Storage Service)
#############################################

# -----------------------------
# Naming
# -----------------------------

resource "random_id" "suffix" {
  count       = var.use_random_suffix ? 1 : 0
  byte_length = 3
}

locals {
  full_bucket_name = var.use_random_suffix ? "${var.name_prefix}-${var.bucket_name}-${random_id.suffix[0].hex}" : "${var.name_prefix}-${var.bucket_name}"
}

# -----------------------------
# Bucket
# -----------------------------

resource "aws_s3_bucket" "this" {
  bucket        = local.full_bucket_name
  force_destroy = var.force_destroy
  tags = merge(var.tags, {
    Name = local.full_bucket_name
  })
}

# -----------------------------
# Block Public Access
# -----------------------------

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -----------------------------
# Versioning
# -----------------------------

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# -----------------------------
# Encryption by default
# -----------------------------

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

# -----------------------------
# Lifecycle rule
# -----------------------------

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.lifecycle_enabled ? 1 : 0
  bucket = aws_s3_bucket.this.id
  rule {
    id     = "expire-objects"
    status = "Enabled"
    expiration {
      days = var.lifecycle_expire_days
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
  depends_on = [aws_s3_bucket_versioning.this]
}
