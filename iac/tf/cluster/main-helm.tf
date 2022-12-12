# Helm Resources (imported from modules)

# Rucio

resource "helm_release" "rucio-daemons-chart" {
  name       = "rucio-daemons-${var.release-suffix}"
  repository = "https://rucio.github.io/helm-charts"
  chart      = "rucio-daemons"
  version    = "1.30.0"
  namespace  = var.ns-name

  values = [
    file("rucio/values-daemons.yaml")
  ]
}

resource "helm_release" "rucio-ui-chart" {
  name       = "rucio-ui-${var.release-suffix}"
  repository = "https://rucio.github.io/helm-charts"
  chart      = "rucio-ui"
  version    = "1.30.0"
  namespace  = var.ns-name

  values = [
    file("rucio/values-ui.yaml")
  ]
}

resource "helm_release" "rucio-server-chart" {
  name       = "rucio-server-${var.release-suffix}"
  repository = "https://rucio.github.io/helm-charts"
  chart      = "rucio-server"
  version    = "1.30.0"
  namespace  = var.ns-name

  values = [
    file("rucio/values.yaml")
  ]
}

module "rucio-server" {
  source = "../modules/rucio/rucio-server"

  ns-name        = var.ns-rucio
  release-suffix = var.resource-suffix
}

module "rucio-ui" {
  source = "../modules/rucio/rucio-ui"

  ns-name        = var.ns-rucio
  release-suffix = var.resource-suffix
} */

# Sealed Secrets

module "sealed-secrets" {
  source = "../modules/sealed-secrets"

  ns-name        = var.ns-shared-services
  release-suffix = var.resource-suffix
}

# JupyterHub

/* module "jupyterhub" {
  source = "../modules/jupyterhub"

  ns-name        = var.ns-jupyterhub
  release-suffix = var.resource-suffix
} */

# Reana

module "reana" {
  source = "../modules/reana"

  ns-name         = var.ns-reana
  release-suffix  = var.resource-suffix
  storage-backend = "chepfs"
  share-id        = data.openstack_sharedfilesystem_share_v2.share_1_reana.id
  share-access-id = openstack_sharedfilesystem_share_access_v2.share_access_2.id
  cephfs-type     = var.cephfs-type
}