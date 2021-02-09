resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name        = "terraform-provider-proxmox-ubuntu-vm"
  description = "Managed by Terraform"
  
  node_name = "pve2"
  
  clone {
    vm_id = 9000
  }

  agent {
    enabled = false
  }
  
  disk {
    datastore_id = "local-lvm"
    size = 20
  }

  initialization {
    datastore_id = "local-lvm"  
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      keys     = ["${trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)}"]
      password = "${random_password.ubuntu_vm_password.result}"
      username = "ubuntu"
    }
    
  }

  network_device {}

  operating_system {
    type = "l26"
  }

  serial_device {}
}

resource "random_password" "ubuntu_vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "tls_private_key" "ubuntu_vm_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

output "ubuntu_vm_password" {
  value     = "${random_password.ubuntu_vm_password.result}"
  sensitive = true
}

output "ubuntu_vm_private_key" {
  value     = "${tls_private_key.ubuntu_vm_key.private_key_pem}"
  sensitive = true
}

output "ubuntu_vm_public_key" {
  value = "${tls_private_key.ubuntu_vm_key.public_key_openssh}"
}