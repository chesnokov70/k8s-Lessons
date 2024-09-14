# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 5.13.0"

  name = "${local.env}-vpc"
  cidr = local.vpc_cidr # "10.0.0.0/16"

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 2, k)]     # ["10.0.0.0/18", "10.0.64.0/18"]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 2, k + 2)] # ["10.0.128.0/18", "10.0.192.0/18"]

  public_subnet_tags = { "kubernetes.io/role/elb" = "1" }

  private_subnet_tags = { "kubernetes.io/role/internal-elb" = "1" }

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags
}