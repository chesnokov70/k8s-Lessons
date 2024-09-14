# # https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx/
# resource "helm_release" "external_nginx" {
#   name = "external"
#
#   repository       = "https://kubernetes.github.io/ingress-nginx"
#   chart            = "ingress-nginx"
#   namespace        = "ingress"
#   create_namespace = true
#   version          = "4.11.2"
#
#   values = [file("${path.module}/values/nginx-ingress.yaml")]
#
#   depends_on = [helm_release.aws_lbc]
# }


################################################################################
#################### The equivalent Helm CLI command ###########################
################################################################################
# helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# helm repo update
# helm install external ingress-nginx/ingress-nginx \
# --namespace ingress \
# --create-namespace \
# --version 4.11.2 \
# -f <path_to_your_module>/values/nginx-ingress.yaml