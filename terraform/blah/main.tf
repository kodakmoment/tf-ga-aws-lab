provider "aws" {}

/* variable "ingress_cidr" {
  description = "The IP that will be allowed to access the instances"
  default     = "<CIDR>"
} */

resource "aws_vpc" "vpc" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "eu-north-1a"
}

resource "aws_route_table_association" "igw_all" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_network_interface" "test" {
  subnet_id   = aws_subnet.subnet.id
  private_ips = ["172.16.10.101"]

  tags = {
    Name = "test"
  }
}

/* resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH incomeing"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr]
  }
}

resource "aws_network_interface_sg_attachment" "test" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = aws_network_interface.test.id
}

resource "aws_key_pair" "key" {
  key_name   = "kodak-lab-key"
  public_key = "<SSH PUB KEY>"
} */

data "aws_ami" "ami-latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

resource "aws_instance" "test" {
  ami           = data.aws_ami.ami-latest.id
  instance_type = "t4g.small"
  #key_name      = aws_key_pair.key.key_name

  network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index         = 0
  }
}

resource "aws_eip" "test" {
  vpc = true

  instance                  = aws_instance.test.id
  associate_with_private_ip = "172.16.10.101"
  depends_on                = [aws_internet_gateway.gw]
}

output "test_instance_eip" {
  value = aws_eip.test.public_ip
}
