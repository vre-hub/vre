resource "openstack_compute_keypair_v2" "eosc-future-kp" {
  name = "eosc-future-kp"
}

resource "openstack_containerinfra_cluster_v1" "eosc-future-cluster" {
  name                = "eosc-future"
  cluster_template_id = "22a4c77f-cfe3-47bb-8006-31d02375a3f3"
  master_count        = 3
  node_count          = 5
  keypair             = "eosc-future-kp"
  merge_labels 	      =	true
  flavor              = "m2.2xlarge"
  master_flavor       = "m2.medium"
  labels = {
    cern_enabled="true"
    cvmfs_enabled="true"
    cvmfs_storage_driver="true"
    eos_enabled="true"
    monitoring_enabled="true"
    metrics_server_enabled="true"
    ingress_controller="nginx"
    logging_producer="eosc-future"
    logging_installer="helm"
    logging_include_internal="true"
    grafana_admin_passwd="admin"
    keystone_auth_enabled="true"
    auto_scaling_enabled="true"
    min_node_count="3"
    max_node_count="7"
    }
}
