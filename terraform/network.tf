data "aws_availability_zones" "available" {
  provider = aws.dev
  state    = "available"
}

resource "aws_vpc" "main" {
  provider = aws.dev

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  provider = aws.dev
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_eip" "nat" {
  provider = aws.dev
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
  provider = aws.dev

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "${var.project_name}-nat-gw"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_subnet" "public_1" {
  provider = aws.dev

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-1"
    Type = "Public"
  }
}

resource "aws_subnet" "public_2" {
  provider = aws.dev

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-2"
    Type = "Public"
  }
}

resource "aws_subnet" "private_app_1" {
  provider = aws.dev

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-private-app-subnet-1"
    Type = "Private"
  }
}

resource "aws_subnet" "private_app_2" {
  provider = aws.dev

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-private-app-subnet-2"
    Type = "Private"
  }
}

resource "aws_subnet" "private_mysql_1" {
  provider = aws.dev

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_mysql_subnet_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-private-mysql-subnet-1"
    Type = "Private"
  }
}

resource "aws_subnet" "private_mysql_2" {
  provider = aws.dev

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_mysql_subnet_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-private-mysql-subnet-2"
    Type = "Private"
  }
}

resource "aws_subnet" "private_oracle_1" {
  provider = aws.dev

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_oracle_subnet_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-private-oracle-subnet-1"
    Type = "Private"
  }
}

resource "aws_subnet" "private_oracle_2" {
  provider = aws.dev

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_oracle_subnet_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-private-oracle-subnet-2"
    Type = "Private"
  }
}

resource "aws_subnet" "private_java_db_1" {
  provider = aws.dev

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_java_db_subnet_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-private-java-db-subnet-1"
    Type = "Private"
  }
}

resource "aws_subnet" "private_java_db_2" {
  provider = aws.dev

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_java_db_subnet_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-private-java-db-subnet-2"
    Type = "Private"
  }
}

resource "aws_subnet" "private_java_app_1" {
  provider = aws.dev

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_java_app_subnet_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-private-java-app-subnet-1"
    Type = "Private"
  }
}

resource "aws_subnet" "private_java_app_2" {
  provider = aws.dev

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_java_app_subnet_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-private-java-app-subnet-2"
    Type = "Private"
  }
}

resource "aws_route_table" "public" {
  provider = aws.dev
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table" "private" {
  provider = aws.dev
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

resource "aws_route_table_association" "public_1" {
  provider       = aws.dev
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  provider       = aws.dev
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_app_1" {
  provider       = aws.dev
  subnet_id      = aws_subnet.private_app_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_app_2" {
  provider       = aws.dev
  subnet_id      = aws_subnet.private_app_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_mysql_1" {
  provider       = aws.dev
  subnet_id      = aws_subnet.private_mysql_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_mysql_2" {
  provider       = aws.dev
  subnet_id      = aws_subnet.private_mysql_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_oracle_1" {
  provider       = aws.dev
  subnet_id      = aws_subnet.private_oracle_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_oracle_2" {
  provider       = aws.dev
  subnet_id      = aws_subnet.private_oracle_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_java_db_1" {
  provider       = aws.dev
  subnet_id      = aws_subnet.private_java_db_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_java_db_2" {
  provider       = aws.dev
  subnet_id      = aws_subnet.private_java_db_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_java_app_1" {
  provider       = aws.dev
  subnet_id      = aws_subnet.private_java_app_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_java_app_2" {
  provider       = aws.dev
  subnet_id      = aws_subnet.private_java_app_2.id
  route_table_id = aws_route_table.private.id
}
