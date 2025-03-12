terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # You can use a different backend configuration if needed
  backend "s3" {
    bucket = "splunk-log-forwarder-bucket-test"
    key    = "splunk-forwarder-global.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1" 
}

# Global IAM role for the Splunk Lambda function
resource "aws_iam_role" "splunk_lambda_role" {
  name = "splunk_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "splunk_lambda_policy" {
  name = "splunk_lambda_policy"
  role = aws_iam_role.splunk_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:FilterLogEvents",
          "logs:GetLogEvents",
          "logs:PutSubscriptionFilter"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Output the role ARN to be used by the regional configurations
output "splunk_lambda_role_arn" {
  description = "The ARN of the IAM role for the Splunk Lambda function"
  value       = aws_iam_role.splunk_lambda_role.arn
}

