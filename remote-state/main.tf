terraform {
    required_version = ">= 1.5"
    
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
    region = "eu-central-1"
}

resource "aws_s3_bucket" "splunk-log-forwarder-bucket" {
    bucket = "splunk-log-forwarder-bucket-3"

    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_s3_bucket_versioning" "splunk-log-forwarder" {
    bucket = aws_s3_bucket.splunk-log-forwarder-bucket.bucket
    versioning_configuration{
        status = "Enabled"
        }
}