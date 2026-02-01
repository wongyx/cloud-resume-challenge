# Archive the Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../backend/lambda_code/visitor_counter"
  output_path = "${path.module}/../../../backend/lambda_code/visitor_counter.zip"
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.environment}-${var.project_name}-visitor-counter"
  retention_in_days = var.lambda_log_retention_days

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-lambda-logs"
    }
  )
}

# Lambda Function
resource "aws_lambda_function" "visitor_counter" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.environment}-${var.project_name}-visitor-counter"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "python3.11"
  timeout         = 3
  memory_size     = 128

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.visitor_counter.name
    }
  }

  lifecycle {
    ignore_changes = all
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_log_group,
    aws_iam_role_policy_attachment.lambda_basic_execution,
    aws_iam_role_policy_attachment.lambda_dynamodb_attach
  ]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-visitor-counter-lambda"
    }
  )
}