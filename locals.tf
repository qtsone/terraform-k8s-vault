locals {
  default_policies = [
    {
      path         = "${var.config.secret_backend}/*"
      capabilities = ["create", "read", "update", "delete", "list"]
    },
    {
      path         = "/auth/${var.config.auth_backend}/*"
      capabilities = ["create", "read", "update", "delete", "list"]
    },
    {
      path         = "infra/data/argo*"
      capabilities = ["read"]
    },
    {
      path         = "infra/metadata/argo*"
      capabilities = ["list"]
    }
  ]

  policies = concat(local.default_policies, var.config.policies)
}
