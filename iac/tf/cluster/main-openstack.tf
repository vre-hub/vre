# Openstack Resources (cannot be changed after applied due to limitations of the OpenStack tf provider)

data "openstack_containerinfra_clustertemplate_v1" "cluster_template" {
  name = var.cluster-template-name
}

resource "openstack_compute_keypair_v2" "openstack_cluster_keypair" {
  name = var.keypair-name
}

resource "openstack_containerinfra_cluster_v1" "openstack_cluster" {
  name                = var.cluster-name
  cluster_template_id = data.openstack_containerinfra_clustertemplate_v1.cluster_template
  master_count        = 3
  node_count          = 24
  keypair             = var.cluster-keypair-name
  merge_labels        = true
  flavor              = "m2.xlarge"
  master_flavor       = "m2.medium"
  labels = {
    cern_enabled             = "true"
    cvmfs_enabled            = "true"
    cvmfs_storage_driver     = "true"
    eos_enabled              = "true"
    monitoring_enabled       = "true"
    metrics_server_enabled   = "true"
    ingress_controller       = "nginx"
    logging_producer         = var.logging-producer
    logging_installer        = "helm"
    logging_include_internal = "true"
    grafana_admin_passwd     = "admin"
    keystone_auth_enabled    = "true"
    auto_scaling_enabled     = "true"
    min_node_count           = "2"
    max_node_count           = "24"
  }
}