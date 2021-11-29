output "eks_kubeconfig" {
  description = "Kubeconfig do cluster EKS"
  value = module.eks.kubeconfig
}