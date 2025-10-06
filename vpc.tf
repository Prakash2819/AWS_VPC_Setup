terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my_vpc"
  }
}

# Create Public Subnet
resource "aws_subnet" "mysubnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "my_subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "netgateway" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "my_gateway"
  }
}

# Create Route Table
resource "aws_route_table" "myroute" {
  vpc_id = aws_vpc.myvpc.id

  # Default route to the internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.netgateway.id
  }

  tags = {
    Name = "my_route"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "Aroute" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myroute.id
}

# Output VPC ID
output "vpc_id" {
  value       = aws_vpc.myvpc.id
  description = "The ID of the VPC"
}

# Output Subnet ID
output "public_subnet_id" {
  value       = aws_subnet.mysubnet.id
  description = "The ID of the public subnet"
}

# Output Internet Gateway ID
output "internet_gateway_id" {
  value       = aws_internet_gateway.netgateway.id
  description = "The ID of the Internet Gateway"
}
