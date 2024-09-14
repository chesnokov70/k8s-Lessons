# # https://github.com/prometheus-community/helm-charts/
# # https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack
# resource "helm_release" "kube-prometheus" {
#   name = "kube-prometheus-stack"
#
#   repository       = "https://prometheus-community.github.io/helm-charts"
#   chart            = "kube-prometheus-stack"
#   namespace        = "monitoring"
#   create_namespace = true
#   version          = "62.5.1"
#
#   values = [file("${path.module}/values/prometheus-values.yaml")]
#
#   depends_on = [module.eks_blueprints_addons]
# }


################################################################################
#################### The equivalent Helm CLI command ###########################
################################################################################
# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm repo update
# helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
# --namespace monitoring \
# --create-namespace \
# --version 62.5.1 \
# -f <path_to_your_module>/values/prometheus-values.yaml