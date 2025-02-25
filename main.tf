resource "kubernetes_service_account" "vault_auth" {
  automount_service_account_token = true
  metadata {
    name      = var.config.service_account
    namespace = var.config.namespace
  }
}

resource "kubernetes_secret" "vault_auth" {
  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
  metadata {
    name      = "${var.config.service_account}-secret"
    namespace = var.config.namespace
    annotations = {
      "kubernetes.io/service-account.name" = var.config.service_account
    }
  }
}

resource "kubernetes_cluster_role_binding" "vault_auth" {
  metadata {
    name = var.config.service_account
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.vault_auth.metadata.0.name
    namespace = kubernetes_service_account.vault_auth.metadata.0.namespace
  }
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = var.config.auth_backend
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = var.config.kubernetes_host
  issuer                 = var.config.cluster_issuer
  kubernetes_ca_cert     = kubernetes_secret.vault_auth.data["ca.crt"]
  token_reviewer_jwt     = kubernetes_secret.vault_auth.data["token"]
  disable_iss_validation = true
}

data "vault_policy_document" "default" {
  dynamic "rule" {
    for_each = local.policies
    content {
      path         = rule.value.path
      capabilities = rule.value.capabilities
    }
  }
}

resource "vault_policy" "default" {
  name   = vault_auth_backend.kubernetes.path
  policy = data.vault_policy_document.default.hcl
}

resource "vault_kubernetes_auth_backend_role" "default" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = var.config.role_name
  bound_service_account_names      = var.config.bound_sa_names
  bound_service_account_namespaces = var.config.bound_sa_namespaces
  token_policies                   = [vault_policy.default.name]
  token_ttl                        = 28800
}

resource "vault_mount" "default" {
  count       = var.config.secret_backend_create ? 1 : 0
  path        = var.config.secret_backend
  type        = "kv-v2"
  description = "Backend path for ${var.config.service_account}"
}
