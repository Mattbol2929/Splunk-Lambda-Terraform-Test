variable "lambda_zip_path" {
  description = "Path to the Lambda function zip file"
  type        = string
  default     = "../../src/SplunkLambdaCloudWatchLogsProcessor.zip"
}

variable "hec_host" {
  description = "URL that receives data input"
  type        = string
}

variable "hec_token" {
  description = "Authorization token"
  type        = string
}

variable "elb_cookie_name" {
  description = "Value can be AWSELB, AWSALB, custom, or blank depending on how Splunk is hosted."
  type        = string
  default     = ""
}
