#############################################
# Author: Casaburi, Nicolás Esteban
# IAM locals
#############################################

locals {

  dynamodb_actions = (
    var.dynamodb_access_mode == "read" ? [
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:DescribeTable"
    ] :
    var.dynamodb_access_mode == "write" ? [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:DescribeTable"
      ] : [
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:DescribeTable"
    ]
  )

  s3_actions_bucket_level = [
    "s3:ListBucket"
  ]

  s3_actions_object_level = (
    var.s3_access_mode == "read" ? [
      "s3:GetObject"
    ] :
    var.s3_access_mode == "write" ? [
      "s3:PutObject",
      "s3:AbortMultipartUpload"
      ] : [
      "s3:GetObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload"
    ]
  )

  s3_objects_arn = var.s3_bucket_arn == null ? null : "${var.s3_bucket_arn}/*"
}
