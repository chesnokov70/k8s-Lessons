# # https://artifacthub.io/packages/helm/metrics-server/metrics-server
# resource "helm_release" "metrics_server" {
#   name = "metrics-server"
#
#   repository = "https://kubernetes-sigs.github.io/metrics-server/"
#   chart      = "metrics-server"
#   namespace  = "kube-system"
#   version    = "3.12.1"
#
#   depends_on = [module.eks]
# }


################################################################################
#################### The equivalent Helm CLI command ###########################
################################################################################
# helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
# helm repo update
# helm install metrics-server metrics-server/metrics-server \
# --namespace kube-system \
# --version 3.12.1