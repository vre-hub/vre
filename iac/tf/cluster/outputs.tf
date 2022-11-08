output "api_address" {
  value       = openstack_containerinfra_cluster_v1.openstack-cluster.api_address
  description = "API address of the openstack cluster"
}