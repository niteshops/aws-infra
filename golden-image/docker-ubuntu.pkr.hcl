packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "golden-img-linux-aws"
  instance_type = "t2.micro"
  region        = "ap-south-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "golden-image"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
}

provisioner "shell" {
  environment_vars = [
    "FOO=hello world",
  ]
  inline = [
    "echo Installing openjdk",
    "sleep 2",
    "sudo apt-get update",
    "sudo apt-get install -y openjdk-17-jdk"
  ]
}

provisioner "shell" {
  inline = ["echo This provisioner runs last"]
}
