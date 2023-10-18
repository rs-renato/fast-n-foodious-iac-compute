# configuracao de subnet publica east-1a
resource "aws_subnet" "fnf-subnet-public1-us-east-1a" {
  vpc_id            = aws_vpc.fnf-vpc.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "fnf-subnet-public1 | us-east-1a"
  }
}

# configuracao de subnet privada east-1a
resource "aws_subnet" "fnf-subnet-private1-us-east-1a" {
  vpc_id            = aws_vpc.fnf-vpc.id
  cidr_block        = "10.0.128.0/20"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "fnf-subnet-private1 | us-east-1a"
  }
}

# configuracao de subnet publica east-1b
resource "aws_subnet" "fnf-subnet-public2-us-east-1b" {
  vpc_id            = aws_vpc.fnf-vpc.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "fnf-subnet-public2 | us-east-1b"
  }
}

# configuracao de subnet privada east-1b
resource "aws_subnet" "fnf-subnet-private2-us-east-1b" {
  vpc_id            = aws_vpc.fnf-vpc.id
  cidr_block        = "10.0.144.0/20"
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "fnf-subnet-private2 | us-east-1b"
  }
}