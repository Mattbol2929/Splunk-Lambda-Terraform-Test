output "us_west_2_lambda_function_arn" {
  description = "The ARN of the Lambda function in us-west-2"
  value       = module.splunk_us_west_2.lambda_function_arn
}

output "us_west_2_lambda_function_name" {
  description = "The name of the Lambda function in us-west-2"
  value       = module.splunk_us_west_2.lambda_function_name
}

