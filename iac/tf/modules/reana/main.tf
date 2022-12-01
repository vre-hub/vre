resource "helm_release" "reana-chart" {
  name       = "reana-${var.release-suffix}"
  repository = ""
  chart      = "reana"
  version    = "0.9.0-alpha.7"
  namespace  = "${var.ns-name}"

  values = [
    file("${path.module}/values.yaml")
  ]
}