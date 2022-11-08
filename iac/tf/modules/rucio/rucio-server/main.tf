resource "helm_release" "rucio-server-chart" {
  name       = "rucio-server-${var.release_suffix}"
  repository = "https://rucio.github.io/helm-charts"
  chart      = "rucio-server"
  version    = "1.29.3"
  namespace  = "${var.ns_name}"

  values = [
    file("${path.module}/values.yaml")
  ]
}