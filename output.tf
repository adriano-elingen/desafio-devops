output "eks_endpoint" {
  description = "Endpoint do cluster EKS"
  value = module.eks.cluster_endpoint
}