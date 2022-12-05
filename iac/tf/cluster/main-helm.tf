# Helm Resources (imported from modules)

# Rucio

module "rucio-daemons" {
  source = "../modules/rucio/rucio-daemons"

  ns-name        = var.ns-rucio
  release-suffix = var.resource-suffix
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
}

# Sealed Secrets

module "sealed-secrets" {
  source = "../modules/sealed-secrets"

  ns-name        = var.ns-shared-services
  release-suffix = var.resource-suffix
}

# JupyterHub

module "jupyterhub" {
  source = "../modules/jupyterhub"

  ns-name        = var.ns-jupyterhub
  release-suffix = var.resource-suffix
}

# Reana

module "reana" {
  source = "../modules/reana"

  ns-name        = var.ns-reana
  release-suffix = var.resource-suffix
}