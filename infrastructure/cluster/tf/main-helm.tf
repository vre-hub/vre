# Helm Resources

# Sealed Secrets

resource "helm_release" "sealed-secrets-chart" {
  name       = "sealed-secrets-${var.resource-suffix}"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = "2.7.1"
  namespace  = var.ns-shared-services
}
