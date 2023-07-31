# Kubernetes Data Sources

# Kubernetes Resources

# Namespaces

resource "kubernetes_namespace_v1" "ns_shared_services" {
  metadata {
    name = var.ns-shared-services
  }
}

resource "kubernetes_namespace_v1" "ns_jupyterhub" {
  metadata {
    name = var.ns-jupyterhub
  }
}

# Storage

## StorageClass

### Reclaim Policy Delete

resource "kubernetes_storage_class_v1" "sc_manila-meyrin-cephfs" {
  metadata {
    name = "manila-meyrin-cephfs" # ref.: https://kubernetes.docs.cern.ch/docs/storage/fileshares/
  }
  storage_provisioner    = "cephfs.manila.csi.openstack.org"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  parameters = {
    type                                                    = "Meyrin CephFS" # ref.: https://clouddocs.web.cern.ch/file_shares/share_types.html
    "csi.storage.k8s.io/provisioner-secret-name"            = "os-trustee"
    "csi.storage.k8s.io/provisioner-secret-namespace"       = "kube-system"
    "csi.storage.k8s.io/controller-expand-secret-name"      = "os-trustee"
    "csi.storage.k8s.io/controller-expand-secret-namespace" = "kube-system"
    "csi.storage.k8s.io/node-stage-secret-name"             = "os-trustee"
    "csi.storage.k8s.io/node-stage-secret-namespace"        = "kube-system"
    "csi.storage.k8s.io/node-publish-secret-name"           = "os-trustee"
    "csi.storage.k8s.io/node-publish-secret-namespace"      = "kube-system"
  }
}

### Reclaim Policy Retain

resource "kubernetes_storage_class_v1" "sc_manila-meyrin-cephfs-retain" {
  metadata {
    name = "manila-meyrin-cephfs-retain" # ref.: https://kubernetes.docs.cern.ch/docs/storage/fileshares/
  }
  storage_provisioner    = "cephfs.manila.csi.openstack.org"
  reclaim_policy         = "Retain"
  allow_volume_expansion = true
  parameters = {
    type                                                    = "Meyrin CephFS" # ref.: https://clouddocs.web.cern.ch/file_shares/share_types.html
    "csi.storage.k8s.io/provisioner-secret-name"            = "os-trustee"
    "csi.storage.k8s.io/provisioner-secret-namespace"       = "kube-system"
    "csi.storage.k8s.io/controller-expand-secret-name"      = "os-trustee"
    "csi.storage.k8s.io/controller-expand-secret-namespace" = "kube-system"
    "csi.storage.k8s.io/node-stage-secret-name"             = "os-trustee"
    "csi.storage.k8s.io/node-stage-secret-namespace"        = "kube-system"
    "csi.storage.k8s.io/node-publish-secret-name"           = "os-trustee"
    "csi.storage.k8s.io/node-publish-secret-namespace"      = "kube-system"
  }
}

## PersistentVolumeClaim

### PersistentVolumeClaim for JupyterHub Single User Storage

resource "kubernetes_persistent_volume_claim_v1" "pvc_jhub_singleuser" {
  metadata {
    name = "jhub-singleuser"
    namespace = var.ns-jupyterhub
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "800Gi"
      }
    }
    storage_class_name = "manila-meyrin-cephfs-retain"
  }
}

# DeamonSets

## DeamonSet Manifest for EOS FUSE mount

resource "kubernetes_manifest" "eosfuse" {
  manifest = yamldecode(file("eos/eosfuse.yaml"))
}
