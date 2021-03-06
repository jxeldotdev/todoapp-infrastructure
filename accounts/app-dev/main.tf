provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Environment = "Development"
      Account     = "Development"
      Application = "Todo-App"
      Managed-By  = "Terraform"
      Owner       = "Ops"
    }
  }
  assume_role {
    role_arn = var.iam_role_arn
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.40"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-state-jfreeman-dev"
    key            = "terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-state-jfreeman-dev"
  }
}

data "aws_caller_identity" "current" {}

module "iam_assumable_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "~> 3.0"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
    "arn:aws:iam::${var.auth_account_id}:root"
  ]

  create_admin_role       = true
  admin_role_requires_mfa = true
  admin_role_name         = "Administrator"

  create_poweruser_role       = true
  poweruser_role_requires_mfa = true
  poweruser_role_name         = "Developer"

  create_readonly_role = false
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "todo-backend-ci-files"
  acl    = "private"

  versioning = {
    enabled = true
  }

}