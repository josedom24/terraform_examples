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
  pool = "ext-net"
}

resource "openstack_networking_network_v2" "red-ext" {
  name = "red-ext"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subred-ext" {
  name = "subred-ext"
  network_id = "${openstack_networking_network_v2.red-ext.id}"
  cidr = "192.168.200.0/24"
  dns_nameservers = ["192.168.102.2"]
  ip_version = 4
}

resource "openstack_networking_network_v2" "red-int" {
  name = "red-int"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subred-int" {
  name = "subred-int"
  network_id = "${openstack_networking_network_v2.red-int.id}"
  cidr = "192.168.201.0/24"
  ip_version = 4
}



resource "openstack_compute_instance_v2" "cliente" {
  name = "cliente"
  region = "RegionOne"
  image_id = "dbefe807-8315-424f-b3cd-1808666fcd13"
  flavor_id = "12"
  key_pair = "key_jdmr"
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
        user = "debian"
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
  image_id = "63f0ffcb-7574-4729-bed3-8b934f3ddaa6"
  flavor_id = "14"
  key_pair = "key_jdmr"
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
  image_id = "63f0ffcb-7574-4729-bed3-8b934f3ddaa6"
  flavor_id = "14"
  key_pair = "key_jdmr"
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

