# Kubernetes Data Sources

data "kubernetes_secret_v1" "rucio_db_secret" {
  metadata {
    name      = "rucio-server-cvre-rucio-db"
    namespace = "rucio"
  }
}

data "kubernetes_secret_v1" "jhub_db_secret" {
  metadata {
    name      = "jhub-cvre-dbconnectstring"
    namespace = "jhub"
  }
}

data "kubernetes_secret_v1" "jhub_iam_secret" {
  metadata {
    name      = "jhub-cvre-iam-secrets"
    namespace = "jhub"
  }
}

# Kubernetes Resources

# Namespaces

resource "kubernetes_namespace_v1" "ns_shared_services" {
  metadata {
    name = var.ns-shared-services
  }
}

resource "kubernetes_namespace_v1" "ns_rucio" {
  metadata {
    name = var.ns-rucio
  }
}

resource "kubernetes_namespace_v1" "ns_monitoring" {
  metadata {
    name = var.ns-monitoring
  }
}

resource "kubernetes_namespace_v1" "ns_jupyterhub" {
  metadata {
    name = var.ns-jupyterhub
  }
}

resource "kubernetes_namespace_v1" "ns_reana" {
  metadata {
    name = var.ns-reana
  }
}

# Secrets (locally created and enrypted with kubeseal and then applied as a ready manifest)

/* resource "kubernetes_manifest" "<tbd>" {
  manifest = "${yamldecode(file("<tbd>.yaml"))}"
} */

# Storage

# StorageClass

resource "kubernetes_storage_class_v1" "sc_manila-meyrin-cephfs" {
  metadata {
    name = "manila-meyrin-cephfs" # ref.: https://kubernetes.docs.cern.ch/docs/storage/fileshares/
  }
  storage_provisioner  = "cephfs.manila.csi.openstack.org"
  reclaim_policy       = "Delete"
  allow_volume_expansion = true
  parameters = {
    type                                                  = "Meyrin CephFS" # ref.: https://clouddocs.web.cern.ch/file_shares/share_types.html
    "csi.storage.k8s.io/provisioner-secret-name"            = "os-trustee"
    "csi.storage.k8s.io/provisioner-secret-namespace"       = "kube-system"
    "csi.storage.k8s.io/controller-expand-secret-name"      = "os-trustee"
    "csi.storage.k8s.io/controller-expand-secret-namespace" = "kube-system"
    "csi.storage.k8s.io/node-stage-secret-name"            = "os-trustee"
    "csi.storage.k8s.io/node-stage-secret-namespace"        = "kube-system"
    "csi.storage.k8s.io/node-publish-secret-name"           = "os-trustee"
    "csi.storage.k8s.io/node-publish-secret-namespace"      = "kube-system"
  }
}
