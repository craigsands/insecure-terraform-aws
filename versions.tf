terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.12.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key

  assume_role {
    role_arn     = "arn:aws:iam::123456789012:role/terraform"
    session_name = "Terraform"
  }
}

variable "access_key" {
  type    = string
  default = "ThisIsMyAWSUserAccessKey"
}

variable "secret_key" {
  type    = string
  default = "ThisIsMyPrivateSecretSuperSecureAWSKey"
}
