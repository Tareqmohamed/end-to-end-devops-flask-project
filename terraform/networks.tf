resource "aws_vpc" "depi_task_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "depi_task_vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.depi_task_vpc.id
}

resource "aws_subnet" "publicSubnet1" {
  vpc_id                  = aws_vpc.depi_task_vpc.id
  cidr_block              = var.public_subnet1_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet1"
  }
}


resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.depi_task_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "publicSubnetAssoc1" {
  subnet_id      = aws_subnet.publicSubnet1.id
  route_table_id = aws_route_table.publicRouteTable.id
}


resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.depi_task_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP range for more security
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  tags = {
    Name = "MySG"
  }
}

#create key pair
resource "tls_private_key" "depi_task_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "depi_task_key_pair" {
  key_name   = "depi_task_key_pair"
  public_key = tls_private_key.depi_task_key.public_key_openssh

}
# Save the private key to a file
resource "local_file" "private_key_file" {
  filename = "${path.module}/keys/depi_task_private_key.pem"
  content  = tls_private_key.depi_task_key.private_key_pem
}

# Save the public key to a file
resource "local_file" "public_key_file" {
  filename = "${path.module}/keys/depi_task_public_key.pub"
  content  = tls_private_key.depi_task_key.public_key_openssh
}