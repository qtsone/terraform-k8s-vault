terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.6"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35"
    }
  }
  required_version = "~> 1.5"
}
