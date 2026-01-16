#############################################
# Author: Casaburi, Nicolás Esteban
# IAM
#############################################


# -----------------------------
# Lambda trust policy
# -----------------------------

# Trust policy: allow AWS Lambda service to assume this role
data "aws_iam_policy_document" "assume_role_lambda" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# -----------------------------
# Lambda execution role
# -----------------------------

resource "aws_iam_role" "this" {
  name               = "${var.name_prefix}-${var.role_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-role-execution"
  })
}

# -----------------------------
# CloudWatch Logs permissions
# -----------------------------

data "aws_iam_policy_document" "logs" {
  count = var.enable_cloudwatch_logs ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "logs" {
  count  = var.enable_cloudwatch_logs ? 1 : 0
  name   = "${var.name_prefix}-${var.role_name}-policy-logs"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.logs[0].json
}

# -----------------------------
# DynamoDB permissions
# -----------------------------

data "aws_iam_policy_document" "dynamodb" {
  count = var.dynamodb_table_arn != null ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = local.dynamodb_actions
    resources = [var.dynamodb_table_arn]
  }
}

resource "aws_iam_role_policy" "dynamodb" {
  count  = var.dynamodb_table_arn != null ? 1 : 0
  name   = "${var.name_prefix}-${var.role_name}-policy-dynamodb"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.dynamodb[0].json
}

# -----------------------------
# S3 permissions
# -----------------------------

data "aws_iam_policy_document" "s3" {
  count = var.s3_bucket_arn != null ? 1 : 0
  # Bucket-level actions
  statement {
    effect    = "Allow"
    actions   = local.s3_actions_bucket_level
    resources = [var.s3_bucket_arn]
  }
  # Object-level actions
  statement {
    effect    = "Allow"
    actions   = local.s3_actions_object_level
    resources = [local.s3_objects_arn]
  }
}

resource "aws_iam_role_policy" "s3" {
  count  = var.s3_bucket_arn != null ? 1 : 0
  name   = "${var.name_prefix}-${var.role_name}-policy-s3"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.s3[0].json
}

# -----------------------------
# Lambda permissions (Required only if Lambda is attached to a VPC.)
# -----------------------------

resource "aws_iam_role_policy_attachment" "vpc_access" {
  count      = var.enable_vpc_access ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
