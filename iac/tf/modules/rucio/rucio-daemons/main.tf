resource "helm_release" "rucio-daemons-chart" {
  name       = "rucio-daemons-${var.release-suffix}"
  repository = "https://rucio.github.io/helm-charts"
  chart      = "rucio-daemons"
  version    = "1.29.8"
  namespace  = "${var.ns-name}"

  values = [
    file("${path.module}/values.yaml")
  ]
}