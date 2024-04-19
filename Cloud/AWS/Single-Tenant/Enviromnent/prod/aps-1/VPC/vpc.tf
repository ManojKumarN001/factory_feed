###########################     VPC      #############################################
resource "aws_vpc" "factoryfeed_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  tags = {
    Name        = "${var.Name}-Prod-VPC"
    Environment = var.Environment
  }
}


################################## Public Subnets  ##############################################
resource "aws_subnet" "factoryfeed-pub_sub" {
  vpc_id                  = aws_vpc.factoryfeed_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name        = "${var.Subnetpub}-Prod"
    Environment = "${var.Environment}-Prod"
  }
}

################################## Private Subnets  ##############################################

resource "aws_subnet" "factoryfeed-private_sub" {
  vpc_id            = aws_vpc.factoryfeed_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name        = "${var.Subnetprv}-Prod"
    Environment = "${var.Environment}-Prod"
  }
}


############################## Security group  for public Instance###################################################
resource "aws_security_group" "factoryfeed-sg" {
  name        = var.Sg
  description = "allow TLS inbound traffic"
  vpc_id      = aws_vpc.factoryfeed_vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.factoryfeed_vpc.cidr_block]
  }


  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.factoryfeed_vpc.cidr_block]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.factoryfeed_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.Sg}-security"
    Environment = "${var.Environment}"
  }
}



################################ Security Group for MYSQL for  Private Instance ########################################

resource "aws_security_group" "Factoryfeed-mysql-sg" {
  name        = var.sg-mysql
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.factoryfeed_vpc.id


  ingress {
    description = "mysql"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.sg-mysql}-sg"
  }
}



###################################### Internet Gateway ########################################################

resource "aws_internet_gateway" "Factoryfeed-IGW" {
  vpc_id = aws_vpc.factoryfeed_vpc.id
  tags = {
    Name = "${var.Name}-IGW"
  }
}


######################################### Route Table #############################################################

resource "aws_route_table" "Factoryfeed-public_RT" {
  vpc_id = aws_vpc.factoryfeed_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Factoryfeed-IGW.id
  }
  tags = {
    Name = "${var.Name}-public_RT"
  }
}

########################################### Route table association #########################################################

resource "aws_route_table_association" "TF_RT_association" {
  subnet_id      = aws_subnet.factoryfeed-pub_sub.id
  route_table_id = aws_route_table.Factoryfeed-public_RT.id

}

############### Elastic IP for the NAT Gateway ###########################

resource "aws_eip" "Nat-Gateway-EIP" {
  depends_on = [
    aws_route_table_association.TF_RT_association
  ]

  domain = "vpc"
}

resource "aws_nat_gateway" "factoryfeed_NAT" {

  depends_on = [
    aws_eip.Nat-Gateway-EIP
  ]
  allocation_id = aws_eip.Nat-Gateway-EIP.id
  subnet_id     = aws_subnet.factoryfeed-pub_sub.id
  tags = {
    Name = "${var.Name}-nat-gateway"
  }
}

################################################### NAT Route Table ################################################################

resource "aws_route_table" "TF_routeTable-2" {

  depends_on = [
    aws_nat_gateway.factoryfeed_NAT
  ]

  vpc_id = aws_vpc.factoryfeed_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.factoryfeed_NAT.id
  }
  tags = {
    Name        = "${var.Name}routeTable-2"
    description = "Route table of NAT Gate way "
  }
}

################################################ NAT Route table association ####################################################

resource "aws_route_table_association" "TF_NAT_RT_Association" {
  depends_on = [
    aws_route_table.TF_routeTable-2
  ]
  subnet_id      = aws_subnet.factoryfeed-private_sub.id
  route_table_id = aws_route_table.TF_routeTable-2.id
}