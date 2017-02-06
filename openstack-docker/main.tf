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
  image_id = "63f0ffcb-7574-4729-bed3-8b934f3ddaa6"
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
        user = "ubuntu"
        }
    inline = [
      "sudo apt-get install apt-transport-https ca-certificates",
      "curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add",
      "sudo apt-get install software-properties-common",
      "sudo add-apt-repository 'deb https://apt.dockerproject.org/repo/ ubuntu-xenial main'",
      "sudo apt-get update",
      "sudo apt-get -y install docker-engine",
      "sudo apt-get -y install python-simplejson",
      "sudo apt-get -y install python-docker",
      "sudo usermod -a -G docker ubuntu",
      
    ]
  }


}

