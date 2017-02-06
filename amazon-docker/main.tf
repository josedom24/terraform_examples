# Configure the AWS Provider
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "us-east-1"
}



resource "aws_instance" "web" {
   connection {
    user = "ubuntu"
    key_file = "key_jdmr"
  }
  subnet_id = "subnet-0a8ecb51"
  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "ami-e13739f6"

  
  key_name = "key_jdmr"


  # We set the name as a tag
  tags {
    "Name" = "prueba"
  }

  # Copies the file as the root user using SSH
  provisioner "file" {
    source = "index.html"
    destination = "/tmp/index.html"
    connection {
        type = "ssh"
        user = "ubuntu"
        }
}

  provisioner "remote-exec" {
    connection {
        type = "ssh"
        user = "ubuntu"
        }
    inline = [
      "curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add",

      "sudo apt-get install apt-transport-https ca-certificates",
      "sudo apt-get install software-properties-common",
      "sudo add-apt-repository 'deb https://apt.dockerproject.org/repo/ubuntu-$(lsb_release -cs) main'",
      "sudo apt-get update",
      "sudo apt-get -y install docker-engine",
      
    ]
  }



}

resource "aws_eip" "lb" {
  instance = "${aws_instance.web.id}"
  vpc      = true
}

