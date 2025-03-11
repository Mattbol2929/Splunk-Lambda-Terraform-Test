# Splunk-Lambda-Terraform-Test

Terraform configuration to deploy Splunk log forwarder Lambda function across multiple AWS regions.

## Overview

This Terraform configuration:

1. Deploys a Lambda function that processes CloudWatch logs and forwards them to Splunk
2. Automatically discovers all CloudWatch log groups with the prefix `/aws/lambda`
3. Creates subscription filters for each discovered log group to forward logs to Splunk
4. Supports multi-region deployment with region-specific resource naming

## Architecture

- **Lambda Function**: Processes CloudWatch logs and forwards them to Splunk using the HTTP Event Collector (HEC)
- **IAM Roles and Policies**: Grants the Lambda function permissions to access CloudWatch logs
- **CloudWatch Log Subscription Filters**: Automatically created for all log groups with the prefix `/aws/lambda`

## Module Structure

```
Splunk-Lambda-Terraform-Test/
├── global/              # Global resources (IAM role)
│   └── main.tf          # Global IAM role definition
├── modules/
│   └── splunk/          # The reusable Splunk module
│       ├── main.tf      # Main module resources
│       ├── variables.tf # Module input variables
│       ├── outputs.tf   # Module outputs
│       └── provider.tf  # Provider requirements
├── us-east-1/           # Configuration for us-east-1 region
│   ├── main.tf          # Main configuration
│   └── variables.tf     # Input variables
├── us-east-2/           # Configuration for us-west-2 region
│   ├── main.tf          # Main configuration
│   └── variables.tf     # Input variables
└── src/                 # Lambda function source code
    └── SplunkLambdaCloudWatchLogsProcessor.zip  # Lambda function code
```

## Usage

### Deployment Process

1. First, deploy the global resources:

```bash
cd global
terraform init
terraform apply
```

2. Then, navigate to the region-specific directory:

```bash
cd ../us-east-1  # or ../us-east-2 for us-west-2
```

3. Initialize Terraform:

```bash
terraform init
```

4. Create a `terraform.tfvars` file with your Splunk HEC host and token:

```
hec_host = "https://your-splunk-hec.example.com:8088/services/collector"
hec_token = "your-splunk-hec-token"
```

5. Apply the configuration:

```bash
terraform apply
```

## Key Features

- **Automatic Log Group Discovery**: The module automatically discovers all CloudWatch log groups with the prefix `/aws/lambda` and creates subscription filters for them (excluding the Splunk forwarder Lambda's own log group to prevent recursive logging).
- **Multi-Region Support**: The configuration supports deployment to multiple AWS regions with region-specific resource naming.
- **Global IAM Role**: Uses a single global IAM role for all Lambda functions across regions, following AWS best practices.
- **Customizable**: The module accepts various parameters to customize the Splunk integration, such as acknowledgment settings, timeout values, and more.

## Global IAM Role

This configuration uses a single global IAM role for all Lambda functions across regions, which provides several benefits:

1. **Simplified Management**: Only one IAM role to manage and update
2. **Consistency**: Ensures all Lambda functions have the same permissions
3. **Best Practice**: Follows AWS best practices by not duplicating global resources
4. **Reduced Clutter**: Prevents the creation of multiple similar IAM roles

The global IAM role is defined in the `global` directory and is referenced by the regional configurations using Terraform remote state.

## Required Variables

- `hec_host`: URL for the Splunk HTTP Event Collector
- `hec_token`: Authorization token for the Splunk HTTP Event Collector

## Optional Variables

- `lambda_zip_path`: Path to the Lambda function zip file (default: "../../src/SplunkLambdaCloudWatchLogsProcessor.zip")
- `elb_cookie_name`: Value can be AWSELB, AWSALB, custom, or blank depending on how Splunk is hosted
- Various other parameters for customizing the Splunk integration (see variables.tf for details)
