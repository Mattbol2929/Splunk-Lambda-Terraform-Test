resource "aws_lambda_function" "splunk_lambda_cloudwatchlogs_processor" {
  function_name = "${var.name_prefix}_splunk_lambda_cloudwatchlogs_processor"
  role          = var.lambda_role_arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"
  filename      = var.lambda_zip_path

  environment {
    variables = {
      ACK_REQUIRED      = var.ack_required
      ACK_RETRIES       = var.ack_retries
      ACK_WAIT_SECS     = var.ack_wait_secs
      DEBUG_DATA        = var.debug_data
      ELB_COOKIE_NAME   = var.elb_cookie_name
      HEC_ENDPOINT_TYPE = var.hec_endpoint_type
      HEC_HOST          = var.hec_host
      HEC_TOKEN         = var.hec_token
      REQUEST_TIMEOUT   = var.request_timeout
      SOURCE_TYPE       = var.source_type
      VERIFY_SSL        = var.verify_ssl
    }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "splunk_log_group" {
  name = "/aws/lambda/${var.name_prefix}_splunk_lambda_cloudwatchlogs_processor"
}

# Get all CloudWatch log groups with the prefix /aws/lambda
data "aws_cloudwatch_log_groups" "lambda_log_groups" {
  log_group_name_prefix = "/aws/lambda"
}

# Define the Splunk forwarder Lambda's log group name to exclude
locals {
  splunk_lambda_log_group = "/aws/lambda/${var.name_prefix}_splunk_lambda_cloudwatchlogs_processor"
  
  # Filter out the Splunk forwarder Lambda's own log group
  filtered_log_groups = [
    for log_group in data.aws_cloudwatch_log_groups.lambda_log_groups.log_group_names :
    log_group if log_group != local.splunk_lambda_log_group
  ]
}

# Create a Lambda permission for each log group
resource "aws_lambda_permission" "splunk_lambda_cloudwatchlogs_processor" {
  for_each = toset(local.filtered_log_groups)
  
  statement_id  = "AllowExecutionFromCloudWatchLogs-${replace(each.value, "/", "_")}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.splunk_lambda_cloudwatchlogs_processor.arn
  principal     = "logs.amazonaws.com"
  source_arn    = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:${each.value}:*"
}

# Create a subscription filter for each log group (excluding the Splunk forwarder Lambda's log group)
resource "aws_cloudwatch_log_subscription_filter" "splunk_subscription_filter" {
  for_each = toset(local.filtered_log_groups)
  
  name            = "${var.name_prefix}_splunk_subscription_filter_${replace(each.value, "/", "_")}"
  depends_on      = [aws_lambda_permission.splunk_lambda_cloudwatchlogs_processor]
  filter_pattern  = ""
  log_group_name  = each.value
  destination_arn = aws_lambda_function.splunk_lambda_cloudwatchlogs_processor.arn
}

#resource "aws_secretsmanager_secret" "splunk_hec_token" {
#  name        = "${var.name_prefix}_splunk_hec_token"
#  description = "HEC token used for authorization with Splunk server"
#}

#resource "aws_secretsmanager_secret" "splunk_collector_url" {
#  name        = "${var.name_prefix}_splunk_collector_url"
#  description = "URL for Splunk HTTP Collector"
#}
