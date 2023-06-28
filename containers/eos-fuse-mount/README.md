# EOS FUSE Mount DaemonSet

This Container mounts an EOS storage using FUSE. The container is currently used as a Kubernetes DaemonSet in the cluster.

The secret keytab and config to mount the EOS instance called `EOS_FUSE_SSS_KEYTAB` and `FUSE_EULAKE_CONF_JSON` are stored in GitHub Actions secrets.
