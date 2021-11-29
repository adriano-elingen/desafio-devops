output "eks_endpoint" {
  description = "Endpoint do cluster EKS"
  value = module.eks.cluster_endpoint
}

output "eks_kubeconfig" {
  description = "Kubeconfig do cluster EKS"
  value = module.eks.kubeconfig
}