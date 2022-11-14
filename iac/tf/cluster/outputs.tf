output "cluster-api-address" {
  value       = openstack_containerinfra_cluster_v1.openstack_cluster.api_address
  description = "The API address of the openstack cluster"
}