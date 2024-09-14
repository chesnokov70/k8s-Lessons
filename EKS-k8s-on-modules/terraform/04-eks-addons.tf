# https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/
module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16.3"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

#   enable_metrics_server = true
#   metrics_server = {
#     chart_version = "3.12.1" # https://artifacthub.io/packages/helm/metrics-server/metrics-server
#   }
#
#   enable_cluster_autoscaler = true
#   cluster_autoscaler = {
#     chart_version = "9.37.0" # https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler
#   }
#
#   enable_aws_load_balancer_controller = true
#   aws_load_balancer_controller = {
#     chart_version = "1.8.2" # https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
#     set = [{
#       name  = "enableServiceMutatorWebhook"
#       value = "false" # Turn off mutation webhook for services to avoid ordering issue
#     }]
#   }
#
#   enable_ingress_nginx = true
#   ingress_nginx = {
#     chart_version = "4.11.2" # https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx/
#     values        = [file("${path.module}/values/nginx-ingress.yaml")]
#   }
#
#   enable_cert_manager = true
#   cert_manager = {
#     chart_version = "1.15.3" # https://artifacthub.io/packages/helm/cert-manager/cert-manager
#     wait          = true     # Wait for all Cert-manager related resources to be ready
#   }
#
#   enable_kube_prometheus_stack = true
#   kube_prometheus_stack = {
#     chart_version = "62.6.0" # https://artifacthub.io/packages/helm/kube-prometheus-stack-oci/kube-prometheus-stack/
#     values        = [file("${path.module}/values/prometheus-values.yaml")]
#   }
#
#   eks_addons = {
#     aws-ebs-csi-driver = {
#       most_recent              = true
#       enable_logging           = false
#       service_account_role_arn = module.ebs_csi_driver_irsa_role.iam_role_arn
#     }
#   }

  tags       = local.tags
  depends_on = [module.eks]
}