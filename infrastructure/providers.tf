# Values are pulled in from Jenkins pipeline.
terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

locals {
  aws_configs = {
      dev   = var.environment_config.dev
      prod  = var.environment_config.prod
  }
}

