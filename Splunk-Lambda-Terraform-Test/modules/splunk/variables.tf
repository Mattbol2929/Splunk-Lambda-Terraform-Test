variable "region" {
  description = "The AWS region to deploy resources to"
  type        = string
}

variable "name_prefix" {
  description = "Prefix to add to resource names for multi-region support"
  type        = string
}

variable "lambda_role_arn" {
  description = "The ARN of the IAM role for the Lambda function"
  type        = string
}

variable "lambda_zip_path" {
  description = "Path to the Lambda function zip file"
  type        = string
}

variable "hec_host" {
  description = "URL that receives data input"
  type        = string
}

variable "hec_token" {
  description = "Authorization token"
  type        = string
}

variable "ack_required" {
  description = "Is acknowledgement from Splunk required"
  type        = string
  default     = "false"
}

variable "ack_retries" {
  description = "How many times does the lambda retry for acknowledgement"
  type        = number
  default     = 5
}

variable "ack_wait_secs" {
  description = "How many seconds do we wait for acknowledgement"
  type        = number
  default     = 5
}

variable "debug_data" {
  description = "Default value if not set is false. Set this to true to debug any issues with Lambda."
  type        = string
  default     = "true"
}

variable "source_type" {
  description = "What source type will logs be categorized under in Splunk"
  type        = string
  default     = "aws"
}

variable "verify_ssl" {
  description = "True or false to verify SSL connection for HTTP request to HEC endpoint. Default is true, set to false for test endpoints configured without a trusted CA."
  type        = string
  default     = "true"
}

variable "elb_cookie_name" {
  description = "Value can be AWSELB, AWSALB, custom, or blank depending on how Splunk is hosted."
  type        = string
  default     = ""
}

variable "hec_endpoint_type" {
  description = "raw or event for ingestion data. Default value is raw."
  type        = string
  default     = "raw"
}

variable "request_timeout" {
  description = "Number of seconds for timeout value in HTTP request."
  type        = number
  default     = 5
}
