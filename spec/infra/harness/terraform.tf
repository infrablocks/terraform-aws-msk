terraform {
  required_version = ">= 0.14"

  required_providers {
    aws      = {
      source  = "hashicorp/aws"
      version = "~> 3.33"
    }
    null     = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
  }
}
