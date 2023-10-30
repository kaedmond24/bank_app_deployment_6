########################################
# ###### Configure AWS Provider ###### #
########################################

# ###### AWS East Region Provider ######
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region_east
}

#  ###### AWS West Region Provider ###### 
# Reference 'aws.west'
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}


#############################
# ###### Create VPCs ###### #
#############################

#  ###### East VPC ###### 
resource "aws_vpc" "vpc_d6_east" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name : "vpc_d6_east"
    vpc : "deploy6"
  }
}

resource "aws_route_table" "public_rt_d6_east" {
  vpc_id = aws_vpc.vpc_d6_east.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_d6_east.id
  }

  tags = {
    Name : "public_rt_d6_east"
    vpc : "deploy6"
  }
}

# ###### West VPC ###### 
resource "aws_vpc" "vpc_d6_west" {
  provider   = aws.west
  cidr_block = "10.0.0.0/16"

  tags = {
    Name : "vpc_d6_west"
    vpc : "deploy6"
  }
}

resource "aws_route_table" "public_rt_d6_west" {
  provider = aws.west
  vpc_id   = aws_vpc.vpc_d6_west.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_d6_west.id
  }

  tags = {
    Name : "public_rt_d6_west"
    vpc : "deploy6"
  }
}


################################
# ###### Create Subnets ###### #
################################

# ###### East Subnets ###### 
resource "aws_subnet" "public_subnet_east_a" {
  vpc_id                  = aws_vpc.vpc_d6_east.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.region_east}a"
  map_public_ip_on_launch = true

  tags = {
    Name : "public_subnet_east_a"
    vpc : "deploy6"
    az : "${var.region_east}a"
  }
}

resource "aws_subnet" "public_subnet_east_b" {
  vpc_id                  = aws_vpc.vpc_d6_east.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "${var.region_east}b"
  map_public_ip_on_launch = true

  tags = {
    Name : "public_subnet_east_b"
    vpc : "deploy6"
    az : "${var.region_east}b"
  }
}

resource "aws_internet_gateway" "igw_d6_east" {
  vpc_id = aws_vpc.vpc_d6_east.id

  tags = {
    Name : "igw_d6_east"
    vpc : "deploy6"
  }
}

resource "aws_route_table_association" "public_east_a" {
  subnet_id      = aws_subnet.public_subnet_east_a.id
  route_table_id = aws_route_table.public_rt_d6_east.id
}

resource "aws_route_table_association" "public_east_b" {
  subnet_id      = aws_subnet.public_subnet_east_b.id
  route_table_id = aws_route_table.public_rt_d6_east.id
}

# ###### West VPC Subnets ###### 
resource "aws_subnet" "public_subnet_west_a" {
  provider                = aws.west
  vpc_id                  = aws_vpc.vpc_d6_west.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region_west}a"
  map_public_ip_on_launch = true

  tags = {
    Name : "public_subnet_west_a"
    vpc : "deploy6"
    az : "${var.region_west}a"
  }
}

resource "aws_subnet" "public_subnet_west_b" {
  provider                = aws.west
  vpc_id                  = aws_vpc.vpc_d6_west.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "${var.region_west}b"
  map_public_ip_on_launch = true

  tags = {
    Name : "public_subnet_west_b"
    vpc : "deploy6"
    az : "${var.region_west}b"
  }
}

resource "aws_internet_gateway" "igw_d6_west" {
  provider = aws.west
  vpc_id   = aws_vpc.vpc_d6_west.id

  tags = {
    Name : "igw_d6_west"
    vpc : "deploy6"
  }
}

resource "aws_route_table_association" "public_west_a" {
  provider       = aws.west
  subnet_id      = aws_subnet.public_subnet_west_a.id
  route_table_id = aws_route_table.public_rt_d6_west.id
}

resource "aws_route_table_association" "public_west_b" {
  provider       = aws.west
  subnet_id      = aws_subnet.public_subnet_west_b.id
  route_table_id = aws_route_table.public_rt_d6_west.id
}


########################################
# ###### Create Security Groups ###### #
########################################

# ###### East Security Groups ######
resource "aws_security_group" "app_access_d6_east_sg" {
  vpc_id      = aws_vpc.vpc_d6_east.id
  name        = "app_access_d6_east_sg"
  description = "ssh application traffic"

  tags = {
    Name : "app_access_d6_east_sg"
    vpc : "deploy6"
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ###### West Security Groups ######
resource "aws_security_group" "app_access_d6_west_sg" {
  provider    = aws.west
  vpc_id      = aws_vpc.vpc_d6_west.id
  name        = "app_access_d6_west_sg"
  description = "ssh application traffic"

  tags = {
    Name : "app_access_d6_west_sg"
    vpc : "deploy6"
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


######################################
# ###### Create EC2 Instances ###### #
######################################

# ###### East EC2 Instances ###### 
resource "aws_instance" "app_east_d6_server_1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_access_d6_east_sg.id]
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_subnet_east_a.id
  #   associate_public_ip_address = "true"

  user_data = file("app_server_setup.sh")

  tags = {
    Name : "app_east_d6_server_1"
    vpc : "deploy6"
    az : "${var.region_east}a"
  }

}

resource "aws_instance" "app_east_d6_server_2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_access_d6_east_sg.id]
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_subnet_east_b.id

  user_data = file("app_server_setup.sh")

  tags = {
    Name : "app_east_d6_server_2"
    vpc : "deploy6"
    az : "${var.region_east}b"
  }
}

# ###### West EC2 Instances ###### 
resource "aws_instance" "app_west_d6_server_1" {
  provider               = aws.west
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_access_d6_west_sg.id]
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_subnet_west_a.id

  user_data = file("app_server_setup.sh")

  tags = {
    Name : "app_west_d6_server_1"
    vpc : "deploy6"
    az : "${var.region_west}a"
  }

}

resource "aws_instance" "app_west_d6_server_2" {
  provider               = aws.west
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_access_d6_west_sg.id]
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_subnet_west_b.id

  user_data = file("app_server_setup.sh")

  tags = {
    Name : "app_west_d6_server_2"
    vpc : "deploy6"
    az : "${var.region_west}b"
  }

}

#############################
# ###### Output Data ###### #
#############################

output "app_east_d6_server_1_public_ip" {
  value = aws_instance.app_east_d6_server_1.public_ip
}

output "app_east_d6_server_2_public_ip" {
  value = aws_instance.app_east_d6_server_2.public_ip
}

output "app_west_d6_server_1_public_ip" {
  value = aws_instance.app_west_d6_server_1.public_ip
}

output "app_west_d6_server_2_public_ip" {
  value = aws_instance.app_west_d6_server_2.public_ip
}
