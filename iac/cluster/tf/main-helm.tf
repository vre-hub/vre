# Helm Resources

# Rucio

resource "helm_release" "rucio-server-chart" {
  name       = "rucio-server-${var.resource-suffix}"
  repository = "https://rucio.github.io/helm-charts/"
  chart      = "rucio-server"
  version    = "1.30.0"
  namespace  = var.ns-rucio

  values = [
    "${file("rucio/values-server.yaml")}"
  ]

  set {
    name  = "config.database.default"
    value = data.kubernetes_secret_v1.rucio_db_secret.data.dbconnectstring
  }
}

resource "helm_release" "rucio-daemons-chart" {
  name       = "rucio-daemons-${var.resource-suffix}"
  repository = "https://rucio.github.io/helm-charts/"
  chart      = "rucio-daemons"
  version    = "1.30.4"
  namespace  = var.ns-rucio

  values = [
    "${file("rucio/values-daemons.yaml")}"
  ]

  set {
    name  = "config.database.default"
    value = data.kubernetes_secret_v1.rucio_db_secret.data.dbconnectstring
  }

  set {
    name  = "config.database.pool_size"
    value = "100"
  }
}

resource "helm_release" "rucio-ui-chart" {
  name       = "rucio-ui-${var.resource-suffix}"
  repository = "https://rucio.github.io/helm-charts"
  chart      = "rucio-ui"
  version    = "1.30.0"
  namespace  = var.ns-rucio

  values = [
    "${file("rucio/values-ui.yaml")}"
  ]

  set {
    name  = "config.database.default"
    value = data.kubernetes_secret_v1.rucio_db_secret.data.dbconnectstring
  }
}

# Sealed Secrets

resource "helm_release" "sealed-secrets-chart" {
  name       = "sealed-secrets-${var.resource-suffix}"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = "2.7.1"
  namespace  = var.ns-shared-services
}

# JupyterHub

resource "helm_release" "jupyterhub-chart" {
  name       = "jhub-${var.resource-suffix}"
  repository = "https://jupyterhub.github.io/helm-chart/"
  chart      = "jupyterhub"
  version    = "2.0.0"
  namespace  = var.ns-jupyterhub

  values = [
    "${file("jhub/config.yaml")}"
  ]

  set {
    name  = "hub.db.url"
    value = data.kubernetes_secret_v1.jhub_db_secret.data.dbconnectstring
  }
  set {
    name  = "hub.config.GenericOAuthenticator.client_id"
    value = data.kubernetes_secret_v1.jhub_iam_secret.data.client_id
  }
  set {
    name  = "hub.config.GenericOAuthenticator.client_secret"
    value = data.kubernetes_secret_v1.jhub_iam_secret.data.client_secret
  }
}

# Reana

# manual helm install due to tf helm error
# helm install --devel reana-cvre reanahub/reana --wait --version 0.9.0 --values reana/values.yaml -n reana

# resource "helm_release" "reana-chart" {
#   name       = "reana-${var.resource-suffix}"
#   repository = "https://reanahub.github.io/reana/"
#   chart      = "reana"
#   version    = "0.9.0"
#   namespace  = var.ns-reana

#   values = [
#     "${file("reana/values.yaml")}"
#   ]
# }

# Dask-Gateway install onyl if you already have jupyterhub

# if not working
# helm repo add dask https://helm.dask.org/ && helm repo update && helm upgrade --wait --install --render-subchart-notes dask-gateway dask/dask-gateway --namespace dask-gateway --values dask-gateway/values.yaml 

resource "helm_release" "dask-gateway-chart" {
  name       = "dask-gateway-${var.resource-suffix}"
  repository = "https://helm.dask.org/"
  chart      = "dask/dask-gateway"
  version    = "2023.1.0"
  namespace  = var.ns-dask-gateway

  values = [
    "${file("dask-gateway/values.yaml")}"
  ]
  set {
    name  = "dask-gateway.gateway.auth.jupyterhub.apiToken"
    value = data.kubernetes_secret_v1.daskhub-tokens.data.api-token
  }
}

# Daskhub installs dask gateway + jupyterhub (in same namespace for better resource management)

# if not working: 
# helm repo add dask https://helm.dask.org/ && helm repo update && helm upgrade --wait --install --render-subchart-notes daskhub dask/daskhub --values=dask-secrets.yaml --values=dask-config.yaml --namespace daskhub

resource "helm_release" "daskhub-chart" {
  name       = "daskhub-${var.resource-suffix}"
  repository = "https://helm.dask.org/"
  chart      = "daskhub"
  version    = "2023.1.0"
  namespace  = var.ns-daskhub

  values = [
    "${file("daskhub/values.yaml")}"
  ]

  set {
    name  = "jupyterhub.proxy.secretToken"
    value = data.kubernetes_secret_v1.daskhub-tokens.data.secret-token
  }

  set {
    name  = "jupyterhub.hub.services.dask-gateway-apiToken"
    value = data.kubernetes_secret_v1.daskhub-tokens.data.api-token
  }

  set {
    name  = "dask-gateway.gateway.auth.jupyterhub.apiToken"
    value = data.kubernetes_secret_v1.daskhub-tokens.data.api-token
  }

  set {
    name  = "hub.config.GenericOAuthenticator.client_id"
    value = data.kubernetes_secret_v1.jhub_iam_secret.data.client_id
  }
  set {
    name  = "hub.config.GenericOAuthenticator.client_secret"
    value = data.kubernetes_secret_v1.jhub_iam_secret.data.client_secret
  }
}


