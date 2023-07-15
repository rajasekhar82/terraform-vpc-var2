resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = var.tags  
}
resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy 
  enable_dns_support = var.dns_support
  enable_dns_hostnames = var.dns_hostname
  tags = var.tags

}

resource "aws_security_group" "allow_postgress" {
  name        = "allow_postgress"
  description = "Allow postgress inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = var.postgress_port
    to_port          = var.postgress_port
    protocol         = "tcp"
    cidr_blocks      = var.cidr_list
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.Allow_all]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.tags, { Name = "${var.tags1}-RDS-SG"})
}
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidrblock
  tags  = merge(var.tags, { Name = "timing-public-subnet"}) 
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.Allow_all
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(var.tags, { Name = "timing-public-rt"})
}
resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
  
}
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidrblock
  tags = merge(var.tags, { Name = "timing-private-subnet"})
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, { Name = "timing-private-rt"})
  
}
resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
  
}
resource "aws_subnet" "database_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_cidrblock
  tags = merge(var.tags, { Name = "timing-database-subnet"})
  
}
  resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, { Name = "timing-database-rt"})
  
}
resource "aws_route_table_association" "database" {
  subnet_id = aws_subnet.database_subnet.id
  route_table_id = aws_route_table.database_route_table.id
  
}
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = merge(var.tags, { Name = "timing-EIP"})
  
}
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public_subnet.id
  tags = merge(var.tags, { Name = "timing-NAT"})
  
  
}
resource "aws_route" "private" {
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = var.Allow_all
  nat_gateway_id = aws_nat_gateway.ngw.id
  #depends_on = [ aws_route_table.private ]
  
}
resource "aws_route" "database" {
  route_table_id = aws_route_table.database_route_table.id
  destination_cidr_block = var.Allow_all
  nat_gateway_id = aws_nat_gateway.ngw.id
  #depends_on = [ aws_route_table.private ]
  
}

