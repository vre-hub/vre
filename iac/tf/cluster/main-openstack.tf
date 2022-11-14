# Openstack Resources (cannot be changed after applied due to limitations of the OpenStack tf provider)

resource "openstack_compute_keypair_v2" "openstack_cluster_keypair" {
  name = var.keypair-name
}

resource "openstack_containerinfra_cluster_v1" "openstack_cluster" {
  name                = "eosc-future"
  cluster_template_id = "22a4c77f-cfe3-47bb-8006-31d02375a3f3"
  master_count        = 2
  node_count          = 4
  keypair             = var.keypair-name
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
    min_node_count           = "2"
    max_node_count           = "4"
  }
}