# Openstack Resources (canot be changed after apply due to limitaations of the openstack tf provider)

resource "openstack_compute_keypair_v2" "openstack-keypair" {
  name = "cluster_kp-${var.cluster-resource-suffix}"
}

resource "openstack_containerinfra_cluster_v1" "openstack-cluster" {
  name                = "eosc-future"
  cluster_template_id = "22a4c77f-cfe3-47bb-8006-31d02375a3f3"
  master_count        = 3
  node_count          = 5
  keypair             = var.openstack_keypair_name
  merge_labels        = true
  flavor              = "m2.2xlarge"
  master_flavor       = "m2.medium"
  labels = {
    cern_enabled             = "true"
    cvmfs_enabled            = "true"
    cvmfs_storage_driver     = "true"
    eos_enabled              = "true"
    monitoring_enabled       = "true"
    metrics_server_enabled   = "true"
    ingress_controller       = "nginx"
    logging_producer         = "eosc-future"
    logging_installer        = "helm"
    logging_include_internal = "true"
    grafana_admin_passwd     = "admin"
    keystone_auth_enabled    = "true"
    auto_scaling_enabled     = "true"
    min_node_count           = "3"
    max_node_count           = "7"
  }
}

# Kubernetes Resources

resource "kubernetes_namespace_v1" "ns-shared-services" {
  metadata {
    name = var.shared-services-ns
  }
}

resource "kubernetes_namespace_v1" "ns-rucio" {
  metadata {
    name = var.rucio-ns
  }
}

resource "kubernetes_namespace_v1" "ns-monitoring" {
  metadata {
    name = var.monitoring-ns
  }
}

# Helm Resources

module "helm-rucio-daemons" {
  source = "../modules/rucio/rucio-daemons"

  ns_name        = var.rucio-ns
  release_suffix = var.cluster-resource-suffix
}

module "helm-rucio-server" {
  source = "../modules/rucio/rucio-server"

  ns_name        = var.rucio-ns
  release_suffix = var.cluster-resource-suffix
}

module "helm-rucio-ui" {
  source = "../modules/rucio/rucio-ui"

  ns_name        = var.rucio-ns
  release_suffix = var.cluster-resource-suffix
}

module "helm-sealed-secrets" {
  source = "../modules/sealed-secrets"

  ns_name        = var.shared-services-ns
  release_suffix = var.cluster-resource-suffix
}