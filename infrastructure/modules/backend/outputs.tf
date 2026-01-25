output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.visitor_counter.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.visitor_counter.arn
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = aws_dynamodb_table.visitor_counter.id
}