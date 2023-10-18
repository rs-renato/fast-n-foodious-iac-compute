# configuracao de route table publica
resource "aws_route_table" "fnf-rtb-public" {
  vpc_id = aws_vpc.fnf-vpc.id
  tags = {
    "Name" = "fnf-rtb-public"
  }
}

# configuracao de route table privada
resource "aws_route_table" "fnf-rtb-private" {
  vpc_id = aws_vpc.fnf-vpc.id
  tags = {
    "Name" = "fnf-rtb-private"
  }
}

# configuracao de associations route table 
resource "aws_route_table_association" "fnf-subnet-public1-us-east-1a_subnet" {
  subnet_id      = aws_subnet.fnf-subnet-public1-us-east-1a.id
  route_table_id = aws_route_table.fnf-rtb-public.id
}

resource "aws_route_table_association" "fnf-subnet-private1-us-east-1a_subnet" {
  subnet_id      = aws_subnet.fnf-subnet-private1-us-east-1a.id
  route_table_id = aws_route_table.fnf-rtb-private.id
}

resource "aws_route_table_association" "fnf-subnet-public2-us-east-1b_subnet" {
  subnet_id      = aws_subnet.fnf-subnet-public2-us-east-1b.id
  route_table_id = aws_route_table.fnf-rtb-public.id
}

resource "aws_route_table_association" "fnf-subnet-private2-us-east-1b_subnet" {
  subnet_id      = aws_subnet.fnf-subnet-private2-us-east-1b.id
  route_table_id = aws_route_table.fnf-rtb-private.id
}

# configuracao de route para gateway publico
resource "aws_route" "fnf-public-igw" {
  route_table_id         = aws_route_table.fnf-rtb-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.fnf-igw.id
}

# configuracao de route para gateway privado
resource "aws_route" "fnf-private-ngw" {
  route_table_id         = aws_route_table.fnf-rtb-private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.fnf-nat-public1-us-east-1a.id
}