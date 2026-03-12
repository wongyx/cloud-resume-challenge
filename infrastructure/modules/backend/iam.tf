# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
 name = "${var.environment}-${var.project_name}-lambda-role"


 assume_role_policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Action = "sts:AssumeRole"
       Effect = "Allow"
       Principal = {
         Service = "lambda.amazonaws.com"
       }
     }
   ]
 })


 tags = merge(
   var.common_tags,
   {
     Name = "${var.environment}-lambda-role"
   }
 )
}


# Policy for Lambda to access DynamoDB
resource "aws_iam_policy" "lambda_dynamodb_policy" {
 name        = "${var.environment}-${var.project_name}-lambda-dynamodb-policy"
 description = "Policy for Lambda to access DynamoDB"


 policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Effect = "Allow"
       Action = [
         "dynamodb:UpdateItem"
       ]
       Resource = aws_dynamodb_table.visitor_counter.arn
     }
   ]
 })
}


# Attach DynamoDB policy to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attach" {
 role       = aws_iam_role.lambda_role.name
 policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}


# Attach AWS managed policy for Lambda basic execution (CloudWatch Logs)
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
 role       = aws_iam_role.lambda_role.name
 policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# GitHub OIDC Provider
resource "aws_iam_openid_connect_provider" "github" {
 url             = "https://token.actions.githubusercontent.com"
 client_id_list  = ["sts.amazonaws.com"]
 thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}


# IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions" {
 name = "github-actions-role"
  assume_role_policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Effect = "Allow"
       Action = "sts:AssumeRoleWithWebIdentity"
       Principal = {
         Federated = aws_iam_openid_connect_provider.github.arn
       }
       Condition = {
         StringEquals = {
           "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
         }
         StringLike = {
           "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo_name}:*"
         }
       }
     }
   ]
 })
}


# Attach policies to the role
resource "aws_iam_role_policy_attachment" "github_actions_policy" {
 role       = aws_iam_role.github_actions.name
 policy_arn = aws_iam_policy.github_actions.arn
}


# Define permissions for GitHub Actions
resource "aws_iam_policy" "github_actions" {
 name        = "github-actions-policy"
 description = "Policy for GitHub Actions"
 policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     # S3 - Bucket-level operations
     {
       Effect = "Allow"
       Action = [
         "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:DeleteBucketPolicy",
          "s3:GetBucketAcl",
          "s3:GetBucketCORS",
          "s3:PutBucketCORS",
          "s3:GetBucketWebsite",
          "s3:PutBucketWebsite",
          "s3:DeleteBucketWebsite",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning",
          "s3:GetBucketRequestPayment",
          "s3:GetBucketTagging",
          "s3:PutBucketTagging",
          "s3:GetBucketLogging",
          "s3:PutBucketLogging",
          "s3:GetEncryptionConfiguration",
          "s3:PutEncryptionConfiguration",
          "s3:GetBucketPublicAccessBlock",
          "s3:PutBucketPublicAccessBlock",
          "s3:GetBucketObjectLockConfiguration",
          "s3:GetLifecycleConfiguration",
          "s3:PutLifecycleConfiguration",
          "s3:ListBucket",
          "s3:ListBucketVersions",
          "s3:GetBucketLocation"
       ]
       Resource = "arn:aws:s3:::*cloud-resume*"
     },
    
     # S3 - Object-level operations
     {
       Effect = "Allow"
       Action = [
         "s3:PutObject",
         "s3:GetObject",
         "s3:DeleteObject",
         "s3:GetObjectVersion",
         "s3:PutObjectAcl"
       ]
       Resource = "arn:aws:s3:::*cloud-resume*/*"
     },
    
     # Lambda - Full lifecycle management
     {
       Effect = "Allow"
       Action = [
          "lambda:CreateFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:GetFunction",
          "lambda:GetFunctionConfiguration",
          "lambda:DeleteFunction",
          "lambda:PublishVersion",
          "lambda:CreateAlias",
          "lambda:UpdateAlias",
          "lambda:DeleteAlias",
          "lambda:GetAlias",
          "lambda:ListVersionsByFunction",
          "lambda:AddPermission",
          "lambda:RemovePermission",
          "lambda:GetPolicy",
          "lambda:TagResource",
          "lambda:UntagResource",
          "lambda:ListTags",
          "lambda:PutFunctionEventInvokeConfig",
          "lambda:GetFunctionEventInvokeConfig",
          "lambda:GetFunctionCodeSigningConfig",
          "lambda:GetRuntimeManagementConfig"
       ]
       Resource = "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:${var.environment}-${var.project_name}-visitor-counter"
     },
    
     # CloudFront - Distribution management
     {
       Effect = "Allow"
       Action = [
         "cloudfront:CreateDistribution",
         "cloudfront:GetDistribution",
         "cloudfront:GetDistributionConfig",
         "cloudfront:UpdateDistribution",
         "cloudfront:DeleteDistribution",
         "cloudfront:CreateInvalidation",
         "cloudfront:GetInvalidation",
         "cloudfront:ListInvalidations",
         "cloudfront:TagResource",
         "cloudfront:UntagResource",
         "cloudfront:ListTagsForResource",
         "cloudfront:ListDistributions",
         "cloudfront:GetOriginAccessControl",
         "cloudfront:CreateOriginAccessControl",
         "cloudfront:DeleteOriginAccessControl",
         "cloudfront:UpdateOriginAccessControl",
         "cloudfront:ListOriginAccessControls"
       ]
       Resource = "*"
     },
    
     # DynamoDB - Visitor counter management
     {
       Effect = "Allow"
       Action = [
          "dynamodb:CreateTable",
          "dynamodb:DeleteTable",
          "dynamodb:DescribeTable",
          "dynamodb:DescribeTimeToLive",
          "dynamodb:UpdateTimeToLive",
          "dynamodb:DescribeContinuousBackups",
          "dynamodb:UpdateContinuousBackups",
          "dynamodb:ListTagsOfResource",
          "dynamodb:TagResource",
          "dynamodb:UntagResource",
          "dynamodb:UpdateTable"
       ]
       Resource = "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${var.environment}-${var.project_name}-visitor-counter"
     },

     {
      Effect = "Allow"
       Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem"
       ]
       Resource = "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${var.environment}-${var.project_name}-visitor-counter"
     },
    
     # API Gateway - REST API management
     {
       Effect = "Allow"
       Action = [
         "apigateway:GET",
         "apigateway:POST",
         "apigateway:PUT",
         "apigateway:PATCH",
         "apigateway:DELETE"
       ]
       Resource = [
         "arn:aws:apigateway:${var.aws_region}::/apis",
         "arn:aws:apigateway:${var.aws_region}::/apis/*"
       ]
     },
    
     # ACM - Certificate management
     {
       Effect = "Allow"
       Action = [
         "acm:RequestCertificate",
         "acm:DescribeCertificate",
         "acm:ListCertificates",
         "acm:DeleteCertificate",
         "acm:AddTagsToCertificate",
         "acm:RemoveTagsFromCertificate",
         "acm:ListTagsForCertificate"
       ]
       Resource = "*"
     },
    
     # SSM Parameter Store - Parameter management
     {
       Effect = "Allow"
       Action = [
         "ssm:GetParameter",
         "ssm:GetParameters",
         "ssm:GetParametersByPath",
         "ssm:DescribeParameters"
       ]
       Resource = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/*"
     },


     # CloudWatch
     {
       Effect = "Allow"
       Action = [
         "logs:DescribeLogGroups",
         "logs:ListTagsForResource"
       ]
       Resource = "*"
     },


     # IAM Read Only
     {
       Effect = "Allow"
       Action = [
         "iam:GetRole",
         "iam:GetPolicy",
         "iam:GetPolicyVersion",
         "iam:GetOpenIDConnectProvider",
         "iam:ListRolePolicies",
         "iam:ListAttachedRolePolicies"
       ]
       Resource = "*"
     }
   ]
 })
}
