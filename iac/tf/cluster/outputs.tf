output "cluster-api-address" {
  value       = openstack_containerinfra_cluster_v1.openstack_cluster.api_address
  description = "The API address of the openstack cluster"
}

output "rucio-db-secret" {
  value       = data.kubernetes_secret_v1.rucio_db_secret.data.dbconnectstring
  sensitive   = true
  description = "The db connection string for rucio helm chart"
}