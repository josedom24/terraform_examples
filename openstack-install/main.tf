# Configure the OpenStack Provider
provider "openstack" {
        user_name  = "demo"
        tenant_name = "demo"
        domain_name = "default"
        password  = "${var.secret_key}"
        auth_url  = "https://jupiter.gonzalonazareno.org:5000/v3"
        cacert_file = "gonzalonazareno.crt"
}

# Create a web server

resource "openstack_compute_floatingip_v2" "myip" {
  pool = "${var.ext-net}"
}

resource "openstack_networking_network_v2" "red-ext" {
  name = "red-ext"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subred-ext" {
  name = "subred-ext"
  network_id = "${openstack_networking_network_v2.red-ext.id}"
  cidr = "${var.ip_subred-ext}"
  dns_nameservers = "${var.dns_subred-ext}"
  ip_version = 4
}

resource "openstack_networking_network_v2" "red-int" {
  name = "red-int"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subred-int" {
  name = "subred-int"
  network_id = "${openstack_networking_network_v2.red-int.id}"
  cidr = "${var.ip_subred-int}"
  ip_version = 4
}

resource "openstack_compute_instance_v2" "cliente" {
  name = "cliente"
  region = "RegionOne"
  image_id = "${var.imagen}"
  flavor_id = "${var.sabor}"
  key_pair = "${var.key_ssh}"
  security_groups = ["default"]

  metadata {
    this = "that"
  }
  network {
    name = "demo-net"
    floating_ip = "${openstack_compute_floatingip_v2.myip.address}"
    # Terraform will use this network for provisioning
    access_network = true 
  }
  network {
    uuid = "${openstack_networking_network_v2.red-ext.id}"
  }

  provisioner "remote-exec" {
    connection {
        type = "ssh"
        user = "ubuntu"
        }
    inline = [
      "sudo apt-get update",
#      "sudo apt-get -y upgrade",
    ]
  }


}


resource "openstack_compute_instance_v2" "controller" {
  name = "controller"
  region = "RegionOne"
  image_id = "${var.imagen}"
  flavor_id = "${var.sabor}"
  key_pair = "${var.key_ssh}"
  security_groups = ["default"]

  metadata {
    this = "that"
  }

  network {
    uuid = "${openstack_networking_network_v2.red-ext.id}"
  }

  network {
    uuid = "${openstack_networking_network_v2.red-int.id}"
  }

}

resource "openstack_compute_instance_v2" "computer1" {
  name = "computer1"
  region = "RegionOne"
  image_id = "${var.imagen}"
  flavor_id = "${var.sabor}"
  key_pair = "${var.key_ssh}"
  security_groups = ["default"]

  metadata {
    this = "that"
  }

  network {
    uuid = "${openstack_networking_network_v2.red-ext.id}"
  }

  network {
    uuid = "${openstack_networking_network_v2.red-int.id}"
  }

}

