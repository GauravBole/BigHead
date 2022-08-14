resource "aws_vpc" "airflow-tera-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      Name = "airflow-tera-vpc"
    }
}

resource "aws_internet_gateway" "airflow-tera-igw" {
    vpc_id = aws_vpc.airflow-tera-vpc.id
}

resource "aws_route_table" "public_route_table_terra" {
    vpc_id = aws_vpc.airflow-tera-vpc.id
    tags = {
      Name = "public_route_table_terra"
    }
  
}
resource "aws_route" "public_route_terra" {
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.airflow-tera-igw.id
    route_table_id = aws_route_table.public_route_table_terra.id
}


resource "aws_subnet" "public_subnet_terra" {
    count = length(var.subnets_cidr)
    vpc_id = aws_vpc.airflow-tera-vpc.id
    availability_zone = element(var.azs, count.index)
    cidr_block = element(var.subnets_cidr, count.index)
    tags = {
        Name = "Subnet-terra-${count.index+1}"
    }
}


resource "aws_route_table_association" "route_table_association-terra" {
    route_table_id = aws_route_table.public_route_table_terra.id
    count = length(var.subnets_cidr)
    subnet_id = element(aws_subnet.public_subnet_terra.*.id, count.index)
  
}
