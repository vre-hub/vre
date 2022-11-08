resource "helm_release" "sealed-secrets-chart" {
  name       = "sealed-secrets-${var.release_suffix}"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = "2.7.0"
  namespace  = "${var.ns_name}"

  values = [
    file("${path.module}/values.yaml")
  ]
}