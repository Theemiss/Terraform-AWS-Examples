provider "aws" {
  max_retries = 10
  profile     = "default"

}
# terraform {
#   required_version = ">= 1.0.7"
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 4.9.0"
#     }


#   }

# }