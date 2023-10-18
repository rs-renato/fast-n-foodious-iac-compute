resource "aws_internet_gateway" "fnf-igw" {
  vpc_id = aws_vpc.fnf-vpc.id

  tags = {
    "Name" = "fnf-igw"
  }
}