# Helm Resources

# Rucio

resource "helm_release" "rucio-daemons-chart" {
  name       = "rucio-daemons-${var.resource-suffix}"
  repository = "https://rucio.github.io/helm-charts"
  chart      = "rucio-daemons"
  version    = "1.30.0"
  namespace  = var.ns-rucio
  
  values = [
    "${file("rucio/values-daemons.yaml")}"
  ]

  set {
    name = "config.database.default"
    value = data.kubernetes_secret_v1.rucio_db_secret.data.dbconnectstring
  }
}

resource "helm_release" "rucio-webui-chart" {
  name       = "rucio-webui-${var.resource-suffix}"
  repository = "https://rucio.github.io/helm-charts"
  chart      = "rucio-webui"
  version    = "1.30.0"
  namespace  = var.ns-rucio

  values = [
    "${file("rucio/values-webui.yaml")}"
  ]

  set {
    name = "config.database.default"
    value = data.kubernetes_secret_v1.rucio_db_secret.data.dbconnectstring
  }
}

resource "helm_release" "rucio-server-chart" {
  name       = "rucio-server-${var.resource-suffix}"
  repository = "https://rucio.github.io/helm-charts"
  chart      = "rucio-server"
  version    = "1.30.0"
  namespace  = var.ns-rucio

  values = [
    "${file("rucio/values-server.yaml")}"
  ]

  set {
    name = "config.database.default"
    value = data.kubernetes_secret_v1.rucio_db_secret.data.dbconnectstring
  }
}

# Sealed Secrets

resource "helm_release" "sealed-secrets-chart" {
  name       = "sealed-secrets-${var.resource-suffix}"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = "2.7.1"
  namespace  = var.ns-shared-services
}

/* module "sealed-secrets" {
  source = "../modules/sealed-secrets"

  ns-name        = var.ns-shared-services
  release-suffix = var.resource-suffix
} */

# JupyterHub

/* module "jupyterhub" {
  source = "../modules/jupyterhub"

  ns-name        = var.ns-jupyterhub
  release-suffix = var.resource-suffix
} */

# Reana

/* module "reana" {
  source = "../modules/reana"

  ns-name         = var.ns-reana
  release-suffix  = var.resource-suffix
  storage-backend = "chepfs"
  share-id        = data.openstack_sharedfilesystem_share_v2.share_1_reana.id
  share-access-id = openstack_sharedfilesystem_share_access_v2.share_access_2.id
  cephfs-type     = var.cephfs-type
} */
