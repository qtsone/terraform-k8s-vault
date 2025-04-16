locals {
  default_policies = [
    {
      path         = "${var.config.secret_backend}/*"
      capabilities = ["create", "read", "update", "delete", "list"]
    },
    {
      path         = "auth/${var.config.auth_backend}/*"
      capabilities = ["create", "read", "update", "delete", "list"]
    },
    {
      path         = "${var.config.secret_backend}/data/*"
      capabilities = ["read", "list"]
    },
    {
      path         = "${var.config.secret_backend}/metadata/*"
      capabilities = ["list"]
    }
  ]

  policies = concat(local.default_policies, var.config.policies)
}
