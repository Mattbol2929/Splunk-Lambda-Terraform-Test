# Path to the Lambda function zip file
lambda_zip_path = "../src/SplunkLambdaCloudWatchLogsProcessor.zip"

# The CloudWatch log group to subscribe to the Splunk Lambda function
target_log_group = "/aws/lambda/my-first-tf-lambda-function"

# Splunk HEC host URL
hec_host = "https://splunk-hec.example.com:8088/services/collector"

# Splunk HEC token
hec_token = "your-splunk-hec-token"

# ELB cookie name (if applicable)
elb_cookie_name = ""
