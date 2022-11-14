resource "helm_release" "rucio-server-chart" {
  name       = "rucio-server-${var.release-suffix}"
  repository = "https://rucio.github.io/helm-charts"
  chart      = "rucio-server"
  version    = "1.29.3"
  namespace  = "${var.ns-name}"

  values = [
    file("${path.module}/values.yaml")
  ]
}