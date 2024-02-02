provider "aws" {
    profile = "default"
    region  = "us-west-2"
}


variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable instance_type {}

resource "aws_vpc" "my-tf-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "my-tf-subnet" {
    vpc_id = aws_vpc.my-tf-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}


resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.my-tf-vpc.id
    tags = {
        Name: "${var.env_prefix}-igw"
    }
}

resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = aws_vpc.my-tf-vpc.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
    }
    tags = {
        Name: "${var.env_prefix}-main-rtb"
    }
}

resource "aws_security_group" "my-tf-sg" {
    name = "my-tf-sg"
    vpc_id = aws_vpc.my-tf-vpc.id

    ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 0
        protocol    = "-1"
        to_port     = 0
    }
}
resource "aws_security_group" "allow_http" {
  name = "allow_http"
  description = "Allow HTTP traffic"
  vpc_id = aws_vpc.my-tf-vpc.id
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}
data "aws_ami" "latest-linux" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    filter {
        name = "virtualization-type"
        values = [ "hvm" ]
    }
}
output "aws_ami_id" {
    value = data.aws_ami.latest-linux.id
}

resource "aws_instance" "my-tf-server" {
    ami = data.aws_ami.latest-linux.id
    instance_type = var.instance_type

    subnet_id = aws_subnet.my-tf-subnet.id
    vpc_security_group_ids = [ aws_security_group.my-tf-sg.id, aws_security_group.allow_http.id ]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = "Ubuntu"

    tags = {
        Name: "Ec2-tf"
    }
}

