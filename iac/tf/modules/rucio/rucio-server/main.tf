resource "helm_release" "rucio-server-chart" {
  name       = "rucio-server-${var.release-suffix}"
  repository = "https://rucio.github.io/helm-charts"
  chart      = "rucio-server"
  version    = "1.29.3"
  namespace  = var.ns-name

  values = [
    file("${path.module}/values.yaml", 
    {rucio-server-image-tag = "${var.image-tag}"}, 
    {rucio-vre-dn = "${var.rucio-vre-dn}", 
    {rucio-auth-vre-dn = "${var.rucio-auth-vre-dn}")
  ]
}
