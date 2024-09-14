# output "kubernetes_config" {
#   value = module.eks.kubernetes_config_map
# }
#
# output "cluster_endpoint" {
#   description = "Endpoint for your Kubernetes API server"
#   value       = module.eks.cluster_endpoint
# }
#
# output "cluster_name" {
#   description = "The name of the EKS cluster"
#   value       = module.eks.cluster_name
# }
#
# output "oidc_provider_arn" {
#   description = "The ARN of the OIDC Provider if `enable_irsa = true`"
#   value       = module.eks.oidc_provider_arn
# }
#
# output "cluster_addons" {
#   description = "Map of attribute maps for all EKS cluster addons enabled"
#   value       = module.eks.cluster_addons
# }
#
# output "eks_managed_node_groups" {
#   description = "Map of attribute maps for all EKS managed node groups created"
#   value       = module.eks.eks_managed_node_groups
# }

output "configure_kubectl" {
  description = "Configure kubectl: run the following command to update your kubeconfig"
  value       = "      aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${local.region}          "
}