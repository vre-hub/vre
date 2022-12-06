resource "helm_release" "jupyterhub-chart" {
  name       = "jupyterhub-${var.release-suffix}"
  repository = "https://jupyterhub.github.io/helm-chart/"
  chart      = "jupyterhub"
  version    = "2.0.0"
  namespace  = var.ns-name

  values = [
    file("${path.module}/config.yaml")
  ]
}