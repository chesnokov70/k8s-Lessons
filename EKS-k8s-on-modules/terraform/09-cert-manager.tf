# # https://artifacthub.io/packages/helm/cert-manager/cert-manager
# resource "helm_release" "cert_manager" {
#   name = "cert-manager"
#
#   repository       = "https://charts.jetstack.io"
#   chart            = "cert-manager"
#   namespace        = "cert-manager"
#   create_namespace = true
#   version          = "v1.15.3"
#
#   set {
#     name  = "installCRDs"
#     value = "true"
#   }
#
#   depends_on = [helm_release.external_nginx]
# }


################################################################################
#################### The equivalent Helm CLI command ###########################
################################################################################
# helm repo add jetstack https://charts.jetstack.io
# helm repo update
# helm install cert-manager jetstack/cert-manager \
# --namespace cert-manager \
# --create-namespace \
# --version v1.15.3 \
# --set installCRDs=true