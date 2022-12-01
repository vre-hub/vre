resource "helm_release" "<chart-name>-chart" {
  name       = "sealed-secrets-${var.release-suffix}"
  repository = ""
  chart      = ""
  version    = ""
  namespace  = "${var.ns-name}"

  values = [
    file("${path.module}/values.yaml")
  ]
}