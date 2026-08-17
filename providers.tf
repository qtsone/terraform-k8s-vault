terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.6"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.5"
}
