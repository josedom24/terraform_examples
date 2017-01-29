# Configure the OpenStack Provider
provider "openstack" {
        user_name  = "demo"
        tenant_name = "demo"
        domain_name = "default"
        password  = "40damePI"
        auth_url  = "https://jupiter.gonzalonazareno.org:5000/v3"
        cacert_file = "gonzalonazareno.crt"
}

# Create a web server

resource "openstack_compute_floatingip_v2" "myip" {
  pool = "ext-net"
}

resource "openstack_compute_instance_v2" "basic" {
  name = "basic"
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


  provisioner "remote-exec" {
    connection {
        type = "ssh"
        user = "debian"
        }
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y install apache2",
    
    ]
  }

  # Copies the file as the root user using SSH
  provisioner "file" {
    source = "index.html"
    destination = "/var/www/html/index.html"
    connection {
        type = "ssh"
        user = "debian"
        }
}
}

