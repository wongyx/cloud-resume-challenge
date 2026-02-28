resource "aws_dynamodb_table" "visitor_counter" {
  name           = var.dynamodb_table_name
  billing_mode   = var.billing_mode
  hash_key       = "id"
  
  attribute {
    name = "id"
    type = "S"  # S = String
  }

  server_side_encryption {
    enabled = true
    kms_key_arn = null  # Uses AWS-managed key
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-visitor-counter"
    }
  )
}

# Create an initial item for the counter
resource "aws_dynamodb_table_item" "visitor_counter_init" {
  table_name = aws_dynamodb_table.visitor_counter.name
  hash_key   = aws_dynamodb_table.visitor_counter.hash_key

  item = jsonencode({
    id = {
      S = "visitor_count"
    }
    count = {
      N = "0"
    }
  })

  lifecycle {
    ignore_changes = [item]  # Prevents Terraform from resetting the count
  }
}