terraform {
  required_providers {
    proxmox = {
      source = "blz-ea/proxmox"
      version = "0.3.2-pre-6"
    }
  }
}

provider "proxmox" {
  virtual_environment {
    endpoint = var.pm_api_url
    username = var.pm_user
    password = var.pm_password
    insecure = true
  }
}

