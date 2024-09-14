# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.24.0"

  cluster_name    = "${local.env}-${local.eks_name}"
  cluster_version = local.eks_version

  cluster_endpoint_public_access           = true
  cluster_endpoint_private_access          = true
  enable_cluster_creator_admin_permissions = true
  enable_irsa                              = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = { disk_size = 16 }

  cluster_enabled_log_types = [] # disable cluster logging

  cluster_addons = {
    eks-pod-identity-agent = {
      most_recent    = true
      enable_logging = false
    }
    coredns = {
      most_recent    = true
      enable_logging = false
    }
    kube-proxy = {
      most_recent    = true
      enable_logging = false
    }
    vpc-cni = {
      most_recent    = true
      enable_logging = false
    }
  }

  eks_managed_node_groups = {
    general = {
      desired_size   = 1
      min_size       = 1
      max_size       = 10
      labels         = { role = "general" }

      instance_types = ["c6a.large"] # 26 ponds max
#       instance_types = ["c6a.large", "c7a.medium"]
#       instance_types = ["t3.small"] # 8 ponds max

#       capacity_type  = "ON_DEMAND"
      capacity_type = "SPOT"
    }
  }

  #   spot = {
  #     desired_size = 1
  #     min_size     = 1
  #     max_size     = 5
  #     labels = {
  #       role = "spot"
  #     }
  #     taints = [{
  #       key    = "market"
  #       value  = "spot"
  #       effect = "NO_SCHEDULE"
  #     }]
  #     instance_types = ["t2.micro"]
  #     capacity_type  = "SPOT"
  #   }

  tags       = local.tags
  depends_on = [module.vpc]
}




########################################################
############ EKS CLI command ###########################
########################################################
# eksctl create cluster \
# --name "eks_name" \
# --version "eks_version" \
# --vpc-id "vpc_id" \
# --nodegroup-name general \
# --node-type "c6a.large,c7a.medium" \
# --nodes 2 \
# --nodes-min 1 \
# --nodes-max 10 \
# --node-volume-size 16 \
# --node-labels role=general \
# --subnets "vpc.private_subnets" \
# --managed \
# --public-access \
# --private-access \
# --enable-irsa \
# --as-group-role eks-creator-admin \
# --full-ecr-access \
# --addons "vpc-cni=v1.17.5/v1.12.1" "coredns=v1.9.3/v1.8.7" "kube-proxy=v1.26.3/v1.24.9" "eks-pod-identity-agent=v0.2.0" \
# --disable-cluster-log-types "*"