resource "helm_release" "rucio-ui-chart" {
  name       = "rucio-ui-${var.release-suffix}"
  repository = "https://rucio.github.io/helm-charts"
  chart      = "rucio-ui"
  version    = "1.29.3"
  namespace  = "${var.ns-name}"

  values = [
    file("${path.module}/values.yaml")
  ]
}