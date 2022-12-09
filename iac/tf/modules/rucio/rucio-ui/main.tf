resource "helm_release" "rucio-ui-chart" {
  name       = "rucio-ui-${var.release-suffix}"
  repository = "https://rucio.github.io/helm-charts"
  chart      = "rucio-ui"
  version    = "1.29.3"
  namespace  = var.ns-name

  values = [
    file("${path.module}/values.yaml", 
    {image-tag = "${var.image-tag}"}, 
    {rucio-vre-dn = "${var.rucio-vre-dn}", 
    {rucio-auth-vre-dn = "${var.rucio-auth-vre-dn}", 
    {rucio-ui-vre-dn = "${var.rucio-ui-vre-dn}")
  ]
}
