# aws_resource_provision

## Description

This repository contains the code to provision the AWS resources

## Pre-requisites

- Terraform
- AWS CLI
- AWS Account
- AWS IAM User with AdministratorAccess

## How to use

- Clone the repository
- Create a file named `terraform.tfvars` and add the  corresponding values for the variables in the file `variables.tf`

- Run the following commands

    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

- To destroy the resources, run the following command

    ```bash
    terraform destroy
    ```

- validate the terraform code

    ```bash
    terraform validate
    ```

### available provisions

- VPC & ec2 instance `vpc_ec2`
- VPC & auto scaling group `vpc_asg`
- vpc & transit gateway & auto scaling group `vpc_tgw_asg`
- S3 bucket & sqs queue & cloudwatch event & lambda function `s3_sqs_cwe_lambda`