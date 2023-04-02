resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "Inet_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Inet_gw"
  }
}

resource "aws_route_table" "Pub_rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Inet_gw.id
  }

  tags = {
    Name = "Pub_rtb"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.Pub_rtb.id
}