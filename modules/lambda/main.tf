#############################################
# Author: Casaburi, Nicolás Esteban
# Lambda
#############################################

# -----------------------------
# CloudWatch Logs Retention
# -----------------------------

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.name_prefix}-${var.lambda_name}"
  retention_in_days = var.log_retention_days
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.lambda_name}-logs"
  })
}

# -----------------------------
# Lambda function
# -----------------------------

resource "aws_lambda_function" "this" {
  function_name    = "${var.name_prefix}-${var.lambda_name}"
  description      = var.description
  role             = aws_iam_role.exec.arn
  runtime          = var.runtime
  handler          = var.handler
  filename         = var.package_path
  source_code_hash = filebase64sha256(var.package_path)
  memory_size      = var.memory_mb
  timeout          = var.timeout_seconds
  environment {
    variables = var.env_vars
  }
  dynamic "vpc_config" {
    for_each = var.attach_to_vpc ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }
  depends_on = [
    aws_cloudwatch_log_group.this
  ]
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.lambda_name}"
  })
}
