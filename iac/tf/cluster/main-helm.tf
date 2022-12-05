# Helm Resources (imported from modules)

# Rucio

module "rucio-daemons" {
  source = "../modules/rucio/rucio-daemons"

  ns_name        = var.rucio-ns
  release_suffix = var.resource-suffix
}

module "rucio-server" {
  source = "../modules/rucio/rucio-server"

  ns_name        = var.rucio-ns
  release_suffix = var.resource-suffix
}

module "rucio-ui" {
  source = "../modules/rucio/rucio-ui"

  ns_name        = var.rucio-ns
  release_suffix = var.resource-suffix
}

# Sealed Secrets

module "sealed-secrets" {
  source = "../modules/sealed-secrets"

  ns_name        = var.ns-shared-services
  release_suffix = var.resource-suffix
} 

# JupyterHub

module "jupyterhub" {
  source = "../modules/jupyterhub"

  ns_name        = var.ns-jupyterhub
  release_suffix = var.resource-suffix
} 

# Reana

module "reana" {
  source = "../modules/reana"

  ns_name        = var.ns-reana
  release_suffix = var.resource-suffix
}