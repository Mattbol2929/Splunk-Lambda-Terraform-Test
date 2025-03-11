output "us_east_1_lambda_function_arn" {
  description = "The ARN of the Lambda function in us-east-1"
  value       = module.splunk_us_east_1.lambda_function_arn
}

output "us_east_1_lambda_function_name" {
  description = "The name of the Lambda function in us-east-1"
  value       = module.splunk_us_east_1.lambda_function_name
}


