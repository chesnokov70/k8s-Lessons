# # https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/
# module "eks_blueprints_addons_secrets_store_csi_driver" {
#   source  = "aws-ia/eks-blueprints-addons/aws"
#   version = "~> 1.16.3"
#
#   cluster_name      = module.eks.cluster_name
#   cluster_endpoint  = module.eks.cluster_endpoint
#   cluster_version   = module.eks.cluster_version
#   oidc_provider_arn = module.eks.oidc_provider_arn
#
#   enable_secrets_store_csi_driver              = true
#   secrets_store_csi_driver = {
#     # https://artifacthub.io/packages/helm/secret-store-csi-driver/secrets-store-csi-driver
#     chart_version = "1.4.5"
#   }
#   enable_secrets_store_csi_driver_provider_aws = true
#   secrets_store_csi_driver_provider_aws = {
#     # https://github.com/aws/secrets-store-csi-driver-provider-aws/releases
#      chart_version = "0.3.9"
#   }
#
#   tags = {
#     Environment = local.env
#   }
#   depends_on = [module.eks]
# }