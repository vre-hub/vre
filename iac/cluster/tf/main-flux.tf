# Flux Installation
# terraform apply -target=flux_bootstrap_git.this -target=github_repository_deploy_key.this -target=tls_private_key.flux

resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "this" {
  title      = "flux-cern-vre"
  repository = var.github-repository
  key        = tls_private_key.flux.public_key_openssh
  read_only  = "false"
}

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository_deploy_key.this]
  path       = var.flux-target-path
}

data "flux_install" "main" {
  target_path    = var.flux-target-path
  network_policy = false
  version        = "latest"
}

data "flux_sync" "main" {
  target_path = var.flux-target-path
  url         = "https://github.com/${var.github-org}/${var.github-repository}"
  branch      = "main"
}
