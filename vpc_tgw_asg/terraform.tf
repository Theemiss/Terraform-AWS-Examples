provider "aws" {
  region      = var.aws_region
  max_retries = 10
  profile     = "default"
  #   assume_role {
  #     role_arn = "arn:aws:iam::123456789012:role/role-name"
  #     session_name = "session-name"
  #     external_id = "external-id"
  #   }
}
terraform {
  required_version = ">= 1.0.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
  }

}
