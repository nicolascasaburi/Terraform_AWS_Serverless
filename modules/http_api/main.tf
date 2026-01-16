#############################################
# Author: Casaburi, Nicolás Esteban
# API Gateway
#############################################

# -----------------------------
# API Gateway
# -----------------------------

resource "aws_apigatewayv2_api" "this" {
  name          = "${var.name_prefix}-${var.api_name}"
  protocol_type = "HTTP"
  description   = var.description
  dynamic "cors_configuration" {
    for_each = var.cors_enabled ? [1] : []
    content {
      allow_origins = var.cors_allow_origins
      allow_methods = var.cors_allow_methods
      allow_headers = var.cors_allow_headers
    }
  }
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.api_name}"
  })
}

resource "aws_apigatewayv2_integration" "lambda_proxy" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.lambda_invoke_arn
  payload_format_version = "2.0"
  integration_method     = "POST"
}

resource "aws_apigatewayv2_route" "this" {
  for_each = {
    for k, enabled in var.routes : k => enabled if enabled
  }
  api_id    = aws_apigatewayv2_api.this.id
  route_key = each.key
  target    = "integrations/${aws_apigatewayv2_integration.lambda_proxy.id}"
}

resource "aws_apigatewayv2_stage" "api_gtw_stage" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.stage_name
  auto_deploy = var.auto_deploy
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.api_name}-stage"
  })
}

# -----------------------------
# Resource policy
# -----------------------------

resource "aws_lambda_permission" "allow_apigw_invoke" {
  statement_id  = "AllowExecutionFromHttpApi"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}
