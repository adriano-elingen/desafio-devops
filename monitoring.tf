provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# install monitoring tools
resource "helm_release" "loki_stack" {
  name             = "loki"
  namespace        = "monitoring"
  create_namespace = true
  cleanup_on_fail  = true
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki-stack"

  set {
    name  = "grafana.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.enabled"
    value = "true"
  }

  set {
    name  = "fluent-bit.enabled"
    value = "true"
  }

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }

  depends_on = [module.eks]

}