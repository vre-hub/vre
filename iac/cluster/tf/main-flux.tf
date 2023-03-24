# Flux

resource "tls_private_key" "flux-tls-key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "flux-deploy-key" {
  title      = "flux-cern-vre"
  repository = var.github-repository
  key        = tls_private_key.flux-tls-key.public_key_openssh
  read_only  = "false"
}

resource "flux_bootstrap_git" "flux-bootstrap" {
  depends_on = [github_repository_deploy_key.flux-deploy-key]
  path       = var.flux-target-path
}

data "flux_install" "cluster-main" {
  target_path    = var.flux-target-path
  network_policy = false
  version        = "latest"
}

data "flux_sync" "cluster-main" {
  target_path = var.flux-target-path
  url         = "https://github.com/${var.github-org}/${var.github-repository}"
  branch      = "main"
}
