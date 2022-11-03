# vpc
resource "aws_vpc" "vpc-test" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "vpc-test"
  }
}

# subnet
resource "aws_subnet" "subnet-test" {
  vpc_id            = aws_vpc.vpc-test.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    "Name" = "subnet-test"
  }
}

# internet Gateway
resource "aws_internet_gateway" "igw-test" {
  vpc_id = aws_vpc.vpc-test.id
  tags = {
    "Name" = "igw-test"
  }
}

# route table
resource "aws_route_table" "route-table-test" {
  vpc_id = aws_vpc.vpc-test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-test.id
  }

  tags = {
    "Name" = "route-table-test"
  }
}

# SubnetとRoute tableの関連付け
resource "aws_route_table_association" "route_table_association-test" {
  subnet_id      = aws_subnet.subnet-test.id
  route_table_id = aws_route_table.route-table-test.id
}

# security groupの作成
resource "aws_security_group" "security_group-test" {
  name   = "security_group-test"
  vpc_id = aws_vpc.vpc-test.id
  tags = {
    "Name" = "security_group-test"
  }

  # インバウンドルール
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
