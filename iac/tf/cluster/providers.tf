terraform {
  /* backend "kubernetes" {
    secret_suffix = "state"
    config_path   = "~/.kube/config" # Change to your local config path if necessary (variables cannot be used inside here)
    namespace     = "default"
  } */
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.49.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.1"
    }
  }
}

provider "openstack" {
  # Configuration options are taken from env. variables (this requires you to source the openstack rc file first)
}

provider "kubernetes" {
  # config_context = "default"
  # config_path   = "~/.kube/config" # Change to your local config path if necessary
  host                   = openstack_containerinfra_cluster_v1.openstack_cluster.kubeconfig.host
  cluster_ca_certificate = openstack_containerinfra_cluster_v1.openstack_cluster.kubeconfig.cluster_ca_certificate
  client_certificate     = openstack_containerinfra_cluster_v1.openstack_cluster.kubeconfig.client_certificate
  client_key             = openstack_containerinfra_cluster_v1.openstack_cluster.kubeconfig.client_key

}

provider "helm" {
  kubernetes {
    # config_context = "default"
    # config_path   = "~/.kube/config" # Change to your local config path if necessary
    host                   = openstack_containerinfra_cluster_v1.openstack_cluster.kubeconfig.host
    cluster_ca_certificate = openstack_containerinfra_cluster_v1.openstack_cluster.kubeconfig.cluster_ca_certificate
    client_certificate     = openstack_containerinfra_cluster_v1.openstack_cluster.kubeconfig.client_certificate
    client_key             = openstack_containerinfra_cluster_v1.openstack_cluster.kubeconfig.client_key
  }
}