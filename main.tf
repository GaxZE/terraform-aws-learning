resource "aws_vpc" "freecode-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "freecode"
  }
}

resource "aws_internet_gateway" "freecode-gw" {
  vpc_id = aws_vpc.freecode-vpc.id

  tags = {
    Name = "freecode"
  }
}

resource "aws_route_table" "freecode-rt" {
  vpc_id = aws_vpc.freecode-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.freecode-gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.freecode-gw.id
  }

  tags = {
    Name = "freecode"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.freecode-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "freecode"
  }
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.freecode-rt.id
}

resource "aws_security_group" "allow_web" {
  name        = "allow_tls"
  description = "Allow Web tra ffic"
  vpc_id      = aws_vpc.freecode-vpc.id

  ingress {
    description = "HTTPS Traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP Traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "freecode"
  }
}

resource "aws_network_interface" "freecode-webserver" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.freecode-webserver.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.freecode-gw]
}

resource "aws_instance" "web-server-instance" {
  ami               = var.ec2_ami
  instance_type     = "t2.micro"
  availability_zone = var.availability_zone
  key_name          = var.ec2_key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.freecode-webserver.id
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo Webserver built by terraform > /var/www/html/index.html'
              EOF

  tags = {
    Name = "freecode"
  }
}
