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
    bucket = "splunk-log-forwarder-bucket"
    key    = "splunk-forwarder-us-east-1.tfstate"
    region = "eu-central-1"
  }
}

# Define the regions to deploy to
locals {
  regions = {
    us_east_1 = {
      region_name = "us-east-1"
      prefix      = "use1"
    }
  }
}

# Provider configuration for each region
provider "aws" {
  region = "us-east-1"
}

# Get the global IAM role ARN from the global state
data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "splunk-log-forwarder-bucket"
    key    = "splunk-forwarder-global.tfstate"
    region = "us-east-1"
  }
}

# Deploy the Splunk module to us-east-1
module "splunk_us_east_1" {
  source = "../modules/splunk"
  
  region           = local.regions.us_east_1.region_name
  name_prefix      = local.regions.us_east_1.prefix
  lambda_role_arn  = data.terraform_remote_state.global.outputs.splunk_lambda_role_arn
  lambda_zip_path  = var.lambda_zip_path
  hec_host         = var.hec_host
  hec_token        = var.hec_token
#  elb_cookie_name  = var.elb_cookie_name
}
