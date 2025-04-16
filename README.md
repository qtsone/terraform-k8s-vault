# terraform-k8s-vault

Terraform module to configure the Vault Kubernetes authentication method, enabling Kubernetes pods to authenticate with HashiCorp Vault using service account tokens.

## Features

- Creates a dedicated Kubernetes ServiceAccount for Vault authentication
- Sets up appropriate RBAC permissions via ClusterRoleBinding
- Configures Vault's Kubernetes auth backend with the necessary JWT reviewer credentials
- Creates role bindings to control which service accounts can authenticate
- Establishes policies for authenticated entities
- Optionally creates a KV-v2 secrets engine

## Overview

This module streamlines the integration between Kubernetes and Vault by managing all the necessary components on both sides. When properly configured, Kubernetes pods can obtain Vault secrets using their service account identity without needing to manage separate credentials.

<!-- BEGIN_TF_DOCS -->
[![semantic-release-badge]][semantic-release]

## Usage

Basic usage of this module:

---
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.35 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 4.6 |
## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role_binding.vault_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_secret.vault_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service_account.vault_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [vault_auth_backend.kubernetes](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/auth_backend) | resource |
| [vault_kubernetes_auth_backend_config.kubernetes](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_config) | resource |
| [vault_kubernetes_auth_backend_role.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_role) | resource |
| [vault_mount.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount) | resource |
| [vault_policy.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_policy_document.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config"></a> [config](#input\_config) | (Required) Module configuration | <pre>object({<br/>    # (Required) Kubernetes API Hostname.<br/>    kubernetes_host = string<br/>    cluster_issuer  = optional(string, "kubernetes/serviceaccount")<br/><br/>    #(Required) Vault Auth Backend Path<br/>    auth_backend = string<br/><br/>    # (Optional) ServiceAccount Name<br/>    service_account = optional(string, "vault-auth")<br/><br/>    # (Optional) Namespace. Defaults to "kube-system".<br/>    namespace = optional(string, "kube-system")<br/><br/>    # (Optional) A role associates SA names, namespaces, and policies to control what the SA authenticating with Vault can do.<br/>    role_name = optional(string, "argo")<br/><br/>    # (Required) List of SA names that this role is bound to.<br/>    # It serves as a filter so that only the specified SA are able to authenticate under this role.<br/>    # The use of wildcard patterns allows for matching multiple service accounts that follow a naming convention.<br/>    bound_sa_names = optional(list(string), ["argo*"])<br/><br/>    # (Required) Restricts authentication to SA in the specified namespaces. Wildcards can be used<br/>    bound_sa_namespaces = optional(list(string), ["argo*"])<br/><br/>    # (Optional) Additional policies assigned to this role.<br/>    policies = optional(list(object({<br/>      path         = string<br/>      capabilities = list(string)<br/>    })), [])<br/><br/>    # (Required) Secret Backend path.<br/>    secret_backend = string<br/><br/>    # (Optional) Create Secret Backend. Defaults to true.<br/>    secret_backend_create = optional(bool, true)<br/>  })</pre> | n/a | yes |
## Outputs

No outputs.
---
[semantic-release-badge]: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
[conventional-commits]: https://www.conventionalcommits.org/
[semantic-release]: https://semantic-release.gitbook.io
[semantic-release-badge]: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
[vscode-conventional-commits]: https://marketplace.visualstudio.com/items?itemName=vivaxy.vscode-conventional-commits
<!-- END_TF_DOCS -->
