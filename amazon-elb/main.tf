# Configure the AWS Provider
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "us-east-1"
}


resource "aws_elb" "web" {
  name = "terraform-example-elb"

  subnets         = ["subnet-0a8ecb51"]
  security_groups = ["sg-ebdc5397"]
  instances       = ["${aws_instance.web.id}","${aws_instance.web2.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
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
    source = "index.php"
    destination = "/tmp/index.php"
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
      "sudo apt-get update",
      "sudo apt-get -y install apache2 php libapache2-mod-php",
      "sudo cp /tmp/index.php /var/www/html",
      "sudo rm /var/www/html/index.html",
    ]
  }



}

resource "aws_instance" "web2" {
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
    "Name" = "prueba2"
  }

  # Copies the file as the root user using SSH
  provisioner "file" {
    source = "index.php"
    destination = "/tmp/index.php"
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
      "sudo apt-get update",
      "sudo apt-get -y install apache2 php libapache2-mod-php",
      "sudo cp /tmp/index.php /var/www/html",
      "sudo rm /var/www/html/index.html",
    ]
  }



}

