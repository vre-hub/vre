terraform {
/*   backend "kubernetes" {
    secret_suffix = "state"
    config_path   = "~/.kube/config" # Change to your local config path if necessary
  } */
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.49.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.15.0"
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

/* provider "kubernetes" {
  config_path    = "~/.kube/config" # Change to your local config path if necessary
  config_context = "default"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config" # Change to your local config path if necessary
    config_context = "default"
  }
} */