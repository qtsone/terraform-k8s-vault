variable "config" {
  description = "(Required) Module configuration"
  type = object({
    # (Required) Kubernetes API Hostname.
    kubernetes_host   = string
    cluster_issuer = optional(string, "kubernetes/serviceaccount")

    #(Required) Vault Auth Backend Path
    auth_backend   = string

    # (Optional) ServiceAccount Name
    service_account = optional(string, "vault-auth")

    # (Optional) Namespace. Defaults to "kube-system".
    namespace = optional(string, "kube-system")

    # (Optional) A role associates SA names, namespaces, and policies to control what the SA authenticating with Vault can do.
    role_name = optional(string, "argo")

    # (Required) List of SA names that this role is bound to.
    # It serves as a filter so that only the specified SA are able to authenticate under this role.
    # The use of wildcard patterns allows for matching multiple service accounts that follow a naming convention.
    bound_sa_names = optional(list(string), ["*"])

    # (Required) Restricts authentication to SA in the specified namespaces. Wildcards can be used
    bound_sa_namespaces = optional(list(string), [""])

    # (Optional) Additional policies assigned to this role.
    policies = optional(list(object({
      path         = string
      capabilities = list(string)
    })), [])

    # (Required) Secret Backend path.
    secret_backend = string

    # (Optional) Create Secret Backend. Defaults to true.
    secret_backend_create = optional(bool, true)
  })
}
