# resource "aws_efs_file_system" "eks" {
#   creation_token = "eks"
#
#   performance_mode = "generalPurpose"
#   throughput_mode  = "bursting"
#   encrypted        = true
#
#   # lifecycle_policy {
#   #   transition_to_ia = "AFTER_30_DAYS"
#   # }
# }
#
# resource "aws_efs_mount_target" "zone_a" {
#   file_system_id  = aws_efs_file_system.eks.id
#   subnet_id       = module.vpc.private_subnets[0]
#   security_groups = [module.eks.cluster_security_group_id]
# }
#
# resource "aws_efs_mount_target" "zone_b" {
#   file_system_id  = aws_efs_file_system.eks.id
#   subnet_id       =  module.vpc.private_subnets[1]
#   security_groups = [module.eks.cluster_security_group_id]
# }
#
# # https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/
# module "eks_blueprints_addons_aws_efs_csi_driver" {
#   source  = "aws-ia/eks-blueprints-addons/aws"
#   version = "~> 1.16.3"
#
#   cluster_name      = module.eks.cluster_name
#   cluster_endpoint  = module.eks.cluster_endpoint
#   cluster_version   = module.eks.cluster_version
#   oidc_provider_arn = module.eks.oidc_provider_arn
#
#   eks_addons = {
#     aws-efs-csi-driver = {
#       most_recent              = true
#       enable_logging           = false
#       service_account_role_arn = module.efs_csi_driver_irsa.iam_role_arn
#     }
#   }
#
#   tags = {
#     Environment = local.env
#   }
#   depends_on = [module.eks, module.efs_csi_driver_irsa]
# }
#
# # https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest
# module "efs_csi_driver_irsa" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "~> 5.44.0"
#
#   role_name = "${local.eks_name}-efs-csi-driver"
#
#   attach_efs_csi_policy = true
#
#   oidc_providers = {
#     main = {
#       provider_arn = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
#     }
#   }
#
#   tags = {
#     Environment = local.env
#   }
# }
#
# resource "kubernetes_storage_class_v1" "efs" {
#   metadata {
#     name = "efs"
#   }
#
#   storage_provisioner = "efs.csi.aws.com"
#
#   parameters = {
#     provisioningMode = "efs-ap"
#     fileSystemId     = aws_efs_file_system.eks.id
#     directoryPerms   = "700"
#   }
#
#   mount_options = ["iam"]
#
#   depends_on = [module.eks_blueprints_addons_aws_efs_csi_driver]
# }
#
#
# # # resource "helm_release" "efs_csi_driver" {
# # #   name = "aws-efs-csi-driver"
# # #
# # #   repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
# # #   chart      = "aws-efs-csi-driver"
# # #   namespace  = "kube-system"
# # #   version    = "3.0.5"
# # #
# # #   set {
# # #     name  = "controller.serviceAccount.name"
# # #     value = "efs-csi-controller-sa"
# # #   }
# # #
# # #   set {
# # #     name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
# # #     value = aws_iam_role.efs_csi_driver.arn
# # #   }
# # #
# # #   depends_on = [
# # #     aws_efs_mount_target.zone_a,
# # #     aws_efs_mount_target.zone_b
# # #   ]
# # # }
# #
# # # data "aws_iam_policy_document" "efs_csi_driver" {
# # #   statement {
# # #     actions = ["sts:AssumeRoleWithWebIdentity"]
# # #     effect  = "Allow"
# # #
# # #     condition {
# # #       test     = "StringEquals"
# # # #       variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
# # #       variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
# # #       values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
# # #     }
# # #
# # #     principals {
# # #       identifiers = [module.eks.oidc_provider_arn]
# # # #       identifiers = [aws_iam_openid_connect_provider.eks.arn]
# # #       type        = "Federated"
# # #     }
# # #   }
# # #
# # #   statement {
# # #     actions = ["sts:AssumeRole"]
# # #     effect  = "Allow"
# # #
# # #     principals {
# # #       identifiers = ["eks.amazonaws.com"]
# # #       type        = "Service"
# # #     }
# # #   }
# # # }
# #
# # data "aws_caller_identity" "current" {}
# #
# # resource "aws_iam_role" "efs_csi_driver" {
# #   name               = "${module.eks.cluster_name}-efs-csi-driver"
# #
# #   assume_role_policy = jsonencode({
# #     Version = "2012-10-17",
# #     Statement = [
# #       {
# #         Effect = "Allow",
# #         Principal = {
# #           Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${module.eks.oidc_provider}"
# #         },
# #         Action = "sts:AssumeRoleWithWebIdentity",
# #         Condition = {
# #           StringEquals = {
# #             "${module.eks.oidc_provider}:sub" = "system:serviceaccount:kube-system:efs-csi-controller-sa"
# #           }
# #         }
# #       }
# #     ]
# #   })
# # }
# #
# # # resource "aws_iam_role" "efs_csi_driver" {
# # #   name               = "${module.eks.cluster_name}-efs-csi-driver"
# # #   assume_role_policy = data.aws_iam_policy_document.efs_csi_driver.json
# # # }
# #
# # resource "aws_iam_role_policy_attachment" "efs_csi_driver" {
# #   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
# #   role       = aws_iam_role.efs_csi_driver.name
# # }
# #
# # # resource "aws_eks_pod_identity_association" "efs_csi_driver" {
# # #   cluster_name    = module.eks.cluster_name
# # #   namespace       = "kube-system"
# # #   service_account = "efs-csi-controller-sa"
# # #   role_arn        = aws_iam_role.efs_csi_driver.arn
# # # }