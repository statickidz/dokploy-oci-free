terraform {
  required_version = ">= 1.5"

  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "~> 8.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8"
    }
  }
}

provider "oci" {}
