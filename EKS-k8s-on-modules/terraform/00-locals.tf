locals {
  env         = "dev"
  region      = "us-east-1"
  eks_name    = "eks-by-modules"
  eks_version = "1.30"
  vpc_cidr    = "10.0.0.0/16"
  azs         = slice(data.aws_availability_zones.available.names, 0, 2) # ["us-east-1a", "us-east-1b"]

  tags = {
    Environment = local.env
  }
}

data "aws_availability_zones" "available" {}