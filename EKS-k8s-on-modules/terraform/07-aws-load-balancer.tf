# # https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
# resource "helm_release" "aws_lbc" {
#   name = "aws-load-balancer-controller"
#
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   version    = "1.8.2"
#
#   set {
#     name  = "clusterName"
#     value = module.eks.cluster_name
#   }
#
#   set {
#     name  = "awsRegion"
#     value = local.region
#   }
#
#   set {
#     name  = "rbac.create"
#     value = "true"
#   }
#
#   set {
#     name  = "serviceAccount.create"
#     value = "true"
#   }
#
#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }
#
#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = module.load_balancer_controller_irsa_role.iam_role_arn
#   }
#
#   set {
#     name  = "enableServiceMutatorWebhook"
#     value = "false"
#   }
#
#     set {
#       name  = "vpcId"
#       value = module.vpc.vpc_id
#     }
#
#   depends_on = [helm_release.cluster_autoscaler, module.load_balancer_controller_irsa_role]
# }
#
# # https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest
# module "load_balancer_controller_irsa_role" {
#   source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "~> 5.44.0"
#
#   role_name = "load-balancer-controller"
#   attach_load_balancer_controller_policy = true
#
#   oidc_providers = {
#     main = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
#
#   tags = local.tags
# }
#
#
#
#
#
#
#
#
#
#
#
# resource "aws_iam_role" "aws_lbc" {
#   name = "${module.eks.cluster_name}-aws-lbc"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "sts:AssumeRole",
#           "sts:TagSession"
#         ]
#         Principal = {
#           Service = "pods.eks.amazonaws.com"
#         }
#       }
#     ]
#   })
# }
#
# data "http" "aws_lbc_policy" {
#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
# }
#
# resource "aws_iam_policy" "aws_lbc" {
#   policy = data.http.aws_lbc_policy.response_body
#   name   = "AWSLoadBalancerControllerIAMPolicy"
# }
#
# resource "aws_iam_role_policy_attachment" "aws_lbc" {
#   policy_arn = aws_iam_policy.aws_lbc.arn
#   role       = aws_iam_role.aws_lbc.name
# }
#
# resource "aws_eks_pod_identity_association" "aws_lbc" {
#   cluster_name    = module.eks.cluster_name
#   namespace       = "kube-system"
#   service_account = "aws-load-balancer-controller"
#   role_arn        = aws_iam_role.aws_lbc.arn
# }


################################################################################
#################### The equivalent Helm CLI command ###########################
################################################################################
# helm repo add eks https://aws.github.io/eks-charts
# helm repo update
# helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
# --namespace kube-system \
# --version 1.8.2 \
# --set clusterName=<your_eks_cluster_name> \
# --set awsRegion=<your_aws_region> \
# --set rbac.create=true \
# --set serviceAccount.create=true \
# --set serviceAccount.name=aws-load-balancer-controller \
# --set "serviceAccount.annotations.eks\.amazonaws\.com/role-arn=<your_irsa_role_arn>" \
# --set enableServiceMutatorWebhook=false \
# --set vpcId=<your_vpc_id>