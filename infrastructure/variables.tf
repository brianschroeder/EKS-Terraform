variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  default = "prod"
  type    = string
}

variable "cluster-name" {
  default = "cloudsre-eks-cluster"
  type    = string
}

variable "deploy-nodegroups" {
  default = true
  type    = bool
}

variable "deploy-eksaddons" {
  default = true
  type    = bool
}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))

  default = [
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.13.0-eksbuild.2"
    }
  ]
}

variable "environment_config" {
  default = {
    dev = {
      vpc_id = "vpc-example1"
    }
    prod = {
      vpc_id = "vpc-example2"
    }
  }
}
