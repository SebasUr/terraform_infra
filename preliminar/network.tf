# VPC
resource "aws_vpc" "cms" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "TF_CMS-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cms.id
  tags   = { Name = "TF_CMS-igw" }
}

# Subnets (public + private)
# Public
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.cms.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "TF_CMS-subnet-public1-us-east-1a" }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.cms.id
  cidr_block              = "172.16.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags                    = { Name = "TF_CMS-subnet-public2-us-east-1b" }
}

# Private (two per AZ)
resource "aws_subnet" "private_a1" {
  vpc_id            = aws_vpc.cms.id
  cidr_block        = "172.16.2.0/24"
  availability_zone = "us-east-1a"
  tags              = { Name = "TF_CMS-subnet-private1-us-east-1a" }
}

resource "aws_subnet" "private_a2" {
  vpc_id            = aws_vpc.cms.id
  cidr_block        = "172.16.3.0/24"
  availability_zone = "us-east-1a"
  tags              = { Name = "TF_CMS-subnet-private2-us-east-1a" }
}

resource "aws_subnet" "private_b1" {
  vpc_id            = aws_vpc.cms.id
  cidr_block        = "172.16.5.0/24"
  availability_zone = "us-east-1b"
  tags              = { Name = "TF_CMS-subnet-private1-us-east-1b" }
}

resource "aws_subnet" "private_b2" {
  vpc_id            = aws_vpc.cms.id
  cidr_block        = "172.16.6.0/24"
  availability_zone = "us-east-1b"
  tags              = { Name = "TF_CMS-subnet-private2-us-east-1b" }
}


# Route tables
# Public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cms.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "TF_public-rt" }
}

resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateways: 1 per AZ (2 NAT gateways)
resource "aws_eip" "nat_a_eip" {
  vpc  = true
  tags = { Name = "TF_nat-a-eip" }
}
resource "aws_eip" "nat_b_eip" {
  vpc  = true
  tags = { Name = "TF_nat-b-eip" }
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a_eip.id
  subnet_id     = aws_subnet.public_a.id
  tags          = { Name = "TF_nat-a" }
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b_eip.id
  subnet_id     = aws_subnet.public_b.id
  tags          = { Name = "TF_nat-b" }
  depends_on    = [aws_internet_gateway.igw]
}

# Private route tables (one per AZ) -> route through NAT in same AZ
resource "aws_route_table" "private_rt_a" {
  vpc_id = aws_vpc.cms.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }
  tags = { Name = "TF_private-rt-a" }
}

resource "aws_route_table" "private_rt_b" {
  vpc_id = aws_vpc.cms.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_b.id
  }
  tags = { Name = "TF_private-rt-b" }
}

# Associate private subnets per AZ to their AZ's private route table
resource "aws_route_table_association" "private_a1_assoc" {
  subnet_id      = aws_subnet.private_a1.id
  route_table_id = aws_route_table.private_rt_a.id
}
resource "aws_route_table_association" "private_a2_assoc" {
  subnet_id      = aws_subnet.private_a2.id
  route_table_id = aws_route_table.private_rt_a.id
}
resource "aws_route_table_association" "private_b1_assoc" {
  subnet_id      = aws_subnet.private_b1.id
  route_table_id = aws_route_table.private_rt_b.id
}
resource "aws_route_table_association" "private_b2_assoc" {
  subnet_id      = aws_subnet.private_b2.id
  route_table_id = aws_route_table.private_rt_b.id
}
