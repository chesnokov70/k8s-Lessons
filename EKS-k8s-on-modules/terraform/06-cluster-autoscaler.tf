# # https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler
# resource "helm_release" "cluster_autoscaler" {
#   name = "autoscaler"
#
#   repository = "https://kubernetes.github.io/autoscaler"
#   chart      = "cluster-autoscaler"
#   namespace  = "kube-system"
#   version    = "9.37.0"
#
#   set {
#     name  = "rbac.serviceAccount.name"
#     value = "cluster-autoscaler"
#   }
#
#   set {
#     name  = "autoDiscovery.clusterName"
#     value = module.eks.cluster_name
#   }
#
#   set {
#     name  = "awsRegion"
#     value = local.region
#   }
#
#   set {
#     name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = module.cluster_autoscaler_irsa_role.iam_role_arn
#   }
#
#   depends_on = [helm_release.metrics_server, module.cluster_autoscaler_irsa_role]
# }
#
# # https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest
# module "cluster_autoscaler_irsa_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "~> 5.44.0"
#
#   role_name = "${local.eks_name}-cluster-autoscaler"
#   attach_cluster_autoscaler_policy = true
#   cluster_autoscaler_cluster_names = [module.eks.cluster_name]
#
#   oidc_providers = {
#     main = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:cluster-autoscaler"]
#     }
#   }
#
#   tags = local.tags
# }


################################################################################
#################### The equivalent Helm CLI command ###########################
################################################################################
# helm repo add autoscaler https://kubernetes.github.io/autoscaler
# helm repo update
# helm install autoscaler autoscaler/cluster-autoscaler \
# --namespace kube-system \
# --version 9.37.0 \
# --set rbac.serviceAccount.name=cluster-autoscaler \
# --set autoDiscovery.clusterName=<your_eks_cluster_name> \
# --set awsRegion=<your_aws_region> \
# --set "rbac.serviceAccount.annotations.eks\.amazonaws\.com/role-arn=<your_irsa_role_arn>"