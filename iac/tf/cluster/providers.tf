terraform {
  backend "kubernetes" {
    secret_suffix = "state"
    config_path   = "~/.kube/config" # Change to your local config path if necessary
  }
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.49.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.1"
    }
  }
}

provider "openstack" {
  # Configuration options are taken form env variables thorugh the OpenStack RC File
}

provider "kubernetes" {
  config_path    = "~/.kube/config" # Change to your local config path if necessary
  config_context = "default"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config" # Change to your local config path if necessary
    config_context = "default"
  }
}