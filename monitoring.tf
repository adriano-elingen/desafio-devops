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

  depends_on = [module.eks]

}