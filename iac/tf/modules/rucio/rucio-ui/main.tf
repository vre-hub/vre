resource "helm_release" "rucio-ui-chart" {
  name       = "rucio-ui-${var.release_suffix}"
  repository = "https://rucio.github.io/helm-charts"
  chart      = "rucio-ui"
  version    = "1.29.3"
  namespace  = "${var.ns_name}"

  values = [
    file("${path.module}/values.yaml")
  ]
}