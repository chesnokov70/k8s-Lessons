################################################################################
# EBS CSI Driver Role
################################################################################

# # https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest
# module "ebs_csi_driver_irsa_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "~> 5.44.0"
#
#   role_name = "${local.eks_name}-ebs-csi-driver"
#
#   attach_ebs_csi_policy = true
#
#   oidc_providers = {
#     main = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
#     }
#   }
#
#   tags = local.tags
# }

# resource "aws_eks_pod_identity_association" "ebs_csi_driver" {
#   cluster_name    = module.eks.cluster_name
#   namespace       = "kube-system"
#   service_account = "ebs-csi-controller-sa"
#   role_arn        = module.ebs_csi_driver_irsa.iam_role_arn
# }
#
# resource "aws_eks_addon" "ebs_csi_driver" {
#   cluster_name             = module.eks.cluster_name
#   addon_name               = "aws-ebs-csi-driver"
#   addon_version            = "v1.33.0-eksbuild.1" # aws eks describe-addon-versions --addon-name aws-ebs-csi-driver
#   service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
#
#   depends_on = [module.eks]
# }

# # # Optional: only if you want to encrypt the EBS drives
# # resource "aws_iam_policy" "ebs_csi_driver_encryption" {
# #   name = "${module.eks.cluster_name}-ebs-csi-driver-encryption"
# #
# #   policy = jsonencode({
# #     Version = "2012-10-17"
# #     Statement = [
# #       {
# #         Effect = "Allow"
# #         Action = [
# #           "kms:Decrypt",
# #           "kms:GenerateDataKeyWithoutPlaintext",
# #           "kms:CreateGrant"
# #         ]
# #         Resource = "*"
# #       }
# #     ]
# #   })
# # }
# #
# # # Optional: only if you want to encrypt the EBS drives
# # resource "aws_iam_role_policy_attachment" "ebs_csi_driver_encryption" {
# #   policy_arn = aws_iam_policy.ebs_csi_driver_encryption.arn
# #   role       = aws_iam_role.ebs_csi_driver.name
# # }
