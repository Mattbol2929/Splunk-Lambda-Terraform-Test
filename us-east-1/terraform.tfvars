# Path to the Lambda function zip file
lambda_zip_path = "../src/SplunkLambdaCloudWatchLogsProcessor.zip"

# The CloudWatch log group to subscribe to the Splunk Lambda function
#target_log_group = "/aws/lambda/my-first-tf-lambda-function"

# Splunk HEC host URL
hec_host = "$SPLUNK_COLLECTOR_URL"

# Splunk HEC token
hec_token = "$SPLUNK_HEC_TOKEN"

# ELB cookie name (if applicable)
elb_cookie_name = ""
