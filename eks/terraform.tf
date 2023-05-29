
terraform {

  cloud {
    organization = "midinfotn401"
    workspaces {
      name = "tekouin-terraform-eks"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }
    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = ">= 2.10"
    # }
    # helm = {
    #   source  = "hashicorp/helm"
    #   version = ">= 2.7"
    # }
    # kubectl = {
    #   source  = "gavinbunney/kubectl"
    #   version = ">= 1.14"
    # }

  }



  required_version = "~> 1.3"
}

