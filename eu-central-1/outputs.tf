output "eu_central_1_lambda_function_arn" {
  description = "The ARN of the Lambda function in us-west-2"
  value       = module.splunk_eu_central_1.lambda_function_arn
}

output "eu_central_1_lambda_function_name" {
  description = "The name of the Lambda function in us-west-2"
  value       = module.splunk_eu_central_1.lambda_function_name
}

