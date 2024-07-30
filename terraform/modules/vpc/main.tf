// Allocate an Elastic IP for the NAT gateway
resource "aws_eip" "nat" {
  domain = "vpc"  // This EIP will be used with a NAT gateway in a VPC
}

// Create a NAT gateway in the public subnet
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id  // Associate the EIP with the NAT gateway
  subnet_id     = aws_subnet.public_subnet.id  // Specify the public subnet
}

// Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lambda_vpc.id  // Attach the Internet Gateway to the VPC
}

// Define a route table for the public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lambda_vpc.id  // Attach the route table to the VPC

  // Route to the Internet Gateway for public subnet access
  route {
    cidr_block = "0.0.0.0/0"  // Route all outbound traffic
    gateway_id = aws_internet_gateway.igw.id  // Use the Internet Gateway
  }
}

// Define a route table for the private subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.lambda_vpc.id  // Attach the route table to the VPC

  // Route outbound traffic to the NAT Gateway
  route {
    cidr_block     = "0.0.0.0/0"  // Route all outbound traffic
    nat_gateway_id = aws_nat_gateway.nat_gw.id  // Use the NAT Gateway
  }
}

// Associate the public route table with the public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id  // Public subnet ID
  route_table_id = aws_route_table.public_rt.id  // Public route table ID
}

// Associate the private route table with the first private subnet
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.lambda_subnet_a.id  // Private subnet A ID
  route_table_id = aws_route_table.private_rt.id  // Private route table ID
}

// Associate the private route table with the second private subnet
resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.lambda_subnet_b.id  // Private subnet B ID
  route_table_id = aws_route_table.private_rt.id  // Private route table ID
}

// Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.lambda_vpc.id  // Attach the subnet to the VPC
  cidr_block = "10.0.3.0/24"  // Define the CIDR block for the public subnet
  availability_zone = "us-west-2c"  // Specify the availability zone
  map_public_ip_on_launch = true  // Assign public IPs to instances launched in this subnet

  tags = {
    Name = "public_subnet_example"  // Tag for identification
  }
}

// Create a VPC
resource "aws_vpc" "lambda_vpc" {
  cidr_block           = "10.0.0.0/16"  // Define the CIDR block for the VPC
  enable_dns_support   = true  // Enable DNS support
  enable_dns_hostnames = true  // Enable DNS hostnames

  tags = {
    Name = "lambda_vpc_example"  // Tag for identification
  }
}

// Create the first private subnet
resource "aws_subnet" "lambda_subnet_a" {
  vpc_id     = aws_vpc.lambda_vpc.id  // Attach the subnet to the VPC
  cidr_block = "10.0.1.0/24"  // Define the CIDR block for the first private subnet
  availability_zone = "us-west-2a"  // Specify the availability zone

  tags = {
    Name = "lambda_subnet_a_example"  // Tag for identification
  }
}

// Create the second private subnet
resource "aws_subnet" "lambda_subnet_b" {
  vpc_id     = aws_vpc.lambda_vpc.id  // Attach the subnet to the VPC
  cidr_block = "10.0.2.0/24"  // Define the CIDR block for the second private subnet
  availability_zone = "us-west-2b"  // Specify a different availability zone

  tags = {
    Name = "lambda_subnet_b_example"  // Tag for identification
  }
}

// Define a default security group for instances
resource "aws_security_group" "primary_default" {
  name_prefix = "default-example-"  // Prefix for security group name
  description = "Default security group for all instances in ${aws_vpc.lambda_vpc.id}"  // Description
  vpc_id      = aws_vpc.lambda_vpc.id  // Attach the security group to the VPC

  // Allow all inbound traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0",  // Allow traffic from any IP
    ]
  }

  // Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  // All protocols
    cidr_blocks = ["0.0.0.0/0"]  // Allow traffic to any IP
  }
}