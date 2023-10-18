# configuracqo de nat vpc
resource "aws_eip" "nat" {
  vpc = true
}

# configuracao de nat gatway
resource "aws_nat_gateway" "fnf-nat-public1-us-east-1a" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.fnf-subnet-public1-us-east-1a.id
  depends_on = [ aws_internet_gateway.fnf-igw ]
}
