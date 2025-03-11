output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.splunk_lambda_cloudwatchlogs_processor.arn
}

output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.splunk_lambda_cloudwatchlogs_processor.function_name
}

output "log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.splunk_log_group.name
}

#output "splunk_hec_token_secret_arn" {
#  description = "The ARN of the Splunk HEC token secret"
#  value       = aws_secretsmanager_secret.splunk_hec_token.arn
#}

#output "splunk_collector_url_secret_arn" {
#  description = "The ARN of the Splunk collector URL secret"
#  value       = aws_secretsmanager_secret.splunk_collector_url.arn
#}
