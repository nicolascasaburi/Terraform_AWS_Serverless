#############################################
# Author: Casaburi, Nicolás Esteban
# Modules: IAM, DynamoDB, S3, Lambda, HTTP API
#############################################

# -----------------------------
# IAM module
# -----------------------------

module "iam" {
  source                 = "../../modules/iam"
  name_prefix            = local.name_prefix
  role_name              = "lambda-exec"
  enable_cloudwatch_logs = true
  dynamodb_table_arn     = module.dynamodb.table_arn
  s3_bucket_arn          = module.s3.bucket_arn
  enable_vpc_access      = false
  enable_dynamodb_access = true
  enable_s3_access       = true
  tags = {
    Component = "iam"
  }
}

# -----------------------------
# DynamoDB module
# -----------------------------

module "dynamodb" {
  source      = "../../modules/dynamodb"
  name_prefix = local.name_prefix
  table-name  = "app-items"
  hash_key    = "pk"
  attributes = [
    { name = "pk", type = "S" }
  ]
  enable_ttl         = true
  ttl_attribute_name = "ttl"
  tags = {
    Component = "dynamodb"
  }
}

# -----------------------------
# S3
# -----------------------------

module "s3" {
  source                = "../../modules/s3"
  name_prefix           = local.name_prefix
  bucket_name           = "app-data"
  versioning_enabled    = true
  lifecycle_enabled     = true
  lifecycle_expire_days = 7
  tags = {
    Component = "s3"
  }
}

# -----------------------------
# Lambda module
# -----------------------------

module "lambda" {
  source       = "../../modules/lambda"
  name_prefix  = local.name_prefix
  lambda_name  = "api"
  package_path = "${path.root}/build/lambda.zip"
  runtime      = "python3.12"
  handler      = "handler.handler"
  env_vars = {
    TABLE_NAME = module.dynamodb.table_name
    BUCKET     = module.s3.bucket_name
  }
  role_arn           = module.iam.role_arn
  dynamodb_table_arn = module.dynamodb.table_arn
  s3_bucket_arn      = module.s3.bucket_arn
  attach_to_vpc      = false
  tags = {
    Component = "lambda"
  }
}

# -----------------------------
# HTTP API module
# -----------------------------

module "http_api" {
  source               = "../../modules/http_api"
  name_prefix          = local.name_prefix
  api_name             = "backend"
  lambda_invoke_arn    = module.lambda.function_arn
  lambda_function_name = module.lambda.function_name
  routes = {
    "GET /health"   = true
    "ANY /{proxy+}" = true
  }
  tags = {
    Component = "apigw"
  }
}

# Display API URL in the console
output "api_url" {
  value = module.http_api.api_endpoint
}
