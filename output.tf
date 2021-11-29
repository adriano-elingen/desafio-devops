output "eks_endpoint" {
  description = "Endpoint do cluster EKS"
  value = module.eks.cluster_endpoint
}

output "eks_kubeconfig" {
  description = "Kubeconfig do cluster EKS"
  value = module.eks.kubeconfig
}

output "nginx_lb_info" {
  description = "informacoes LB pod teste"
  value = kubernetes_service.simple-nginx-service.status.0.load_balancer.0.ingress.0.hostname
}

output "grafana_lb_info" {
  description = "informacoes LB grafana"
  value = kubernetes_service.loki-grafana.status.0.load_balancer.0.ingress.0.hostname
}