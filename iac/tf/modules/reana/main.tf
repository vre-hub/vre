resource "helm_release" "reana-chart" {
  name       = "reana-${var.release-suffix}"
  repository = "https://reanahub.github.io/reana"
  chart      = "reana"
  version    = "0.9.0-alpha.7"
  namespace  = "${var.ns-name}"

  set {
    name  = "shared_storage.backend"
    value = "cephfs"
  }
  set {
    name  = "shared_storage.cephfs.availability_zone"
    value = ""
  }
  set {
    name  = "shared_storage.cephfs.cephfs_os_share_access_id"
    value = ""
  }
  set {
    name  = "shared_storage.cephfs.cephfs_os_share_id"
    value = ""
  }
  set {
    name  = "shared_storage.cephfs.os_secret_name"
    value = ""
  }
  set {
    name  = "shared_storage.cephfs.os_secret_namespace"
    value = ""
  }
  set {
    name  = "shared_storage.cephfs.provisioner"
    value = ""
  }
  set {
    name  = "shared_storage.cephfs.type"
    value = ""
  }
}