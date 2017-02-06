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


  # Copies the file as the root user using SSH
  provisioner "file" {
    source = "index.html"
    destination = "/tmp/index.html"
    connection {
        type = "ssh"
        user = "debian"
        }
}

  provisioner "remote-exec" {
    connection {
        type = "ssh"
        user = "debian"
        }
    inline = [
      "sudo apt-get update",
      "sudo apt-get install apt-transport-https ca-certificates",
      "sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D",
      "sudo echo 'deb https://apt.dockerproject.org/repo debian-jessie main'>/etc/apt/sources.list.d/docker.list",
      "sudo apt-get update",
      "sudo apt-get install docker-engine",
      "sudo usermod -a -G docker usuario",
      
    ]
  }


}

