# Configure the OpenStack Provider
provider "openstack" {
        user_name  = "demo"
        tenant_name = "demo"
        domain_name = "default"
        password  = "${var.secret_key}"
        auth_url  = "https://jupiter.gonzalonazareno.org:5000/v3"
        cacert_file = "gonzalonazareno.crt"
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

