
resource "aws_vpc" "app_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = var.vpc_name,
        Environment = var.environment
    }
}

resource "aws_subnet" "app_vpc_public_subnets" {
    vpc_id            = aws_vpc.app_vpc.id
    cidr_block        = var.public_subnet_cidrs
    map_public_ip_on_launch = true
    availability_zone = "${var.aws_region}a"
    tags = {
        Name = var.public_subnet_name,
        Environment = var.environment
    }
}

resource "aws_subnet" "app_vpc_private_subnets" {
    vpc_id            = aws_vpc.app_vpc.id
    cidr_block        = var.private_subnet_cidrs
    availability_zone = "${var.aws_region}a"
    tags = {
        Name = var.private_subnet_name,
        Environment = var.environment
    }
}

resource "aws_internet_gateway" "app_vpc_igw" {
    vpc_id = aws_vpc.app_vpc.id
    tags = {
        Name = var.igw_name
        Environment = var.environment
    }
}

resource "aws_route_table" "app_vpc_public_rt" {
    vpc_id = aws_vpc.app_vpc.id
    tags = {
        Name = var.public_subnet_route_table_name,
        Environment = var.environment
    }
}

resource "aws_route" "aws_vpc_public_subnet_internet_access" {
    route_table_id         = aws_route_table.app_vpc_public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.app_vpc_igw.id
}

resource "aws_route_table_association" "aws_vpc_public_subnet_rt_assoc" {
    subnet_id      = aws_subnet.app_vpc_public_subnets.id
    route_table_id = aws_route_table.app_vpc_public_rt.id
}

# resource "aws_eip" "app_vpc_eip" {
#     domain     = "vpc"
# }

# resource "aws_nat_gateway" "app_vpc_nat" {
#     allocation_id = aws_eip.app_vpc_eip.id
#     subnet_id     = aws_subnet.app_vpc_public_subnets.id
#     tags = {
#         Name = var.natgw_name
#     }
# }

resource "aws_route_table" "app_vpc_private_rt" {
    vpc_id = aws_vpc.app_vpc.id
    tags = {
        Name = var.private_subnet_route_table_name
    }
}

# resource "aws_route" "app_vpc_private_subnet_nat_access" {
#     route_table_id         = aws_route_table.app_vpc_private_rt.id
#     destination_cidr_block = "0.0.0.0/0"
#     nat_gateway_id         = aws_nat_gateway.app_vpc_nat.id
# }

resource "aws_route_table_association" "aws_vpc_private_subnet_rt_assoc" {
    subnet_id      = aws_subnet.app_vpc_private_subnets.id
    route_table_id = aws_route_table.app_vpc_private_rt.id
}

# DHCP option set for VPC
# resource "aws_vpc_dhcp_options" "app_vpc_dhcp_options" {
#     domain_name         = var.domain_name
#     domain_name_servers = var.domain_name_servers
#     tags = {
#         Name        = var.dhcp_option_set_name
#         Environment = var.environment
#     }
# }

# resource "aws_vpc_dhcp_options_association" "app_vpc_dhcp_options_assoc" {
#     vpc_id          = aws_vpc.app_vpc.id
#     dhcp_options_id = aws_vpc_dhcp_options.app_vpc_dhcp_options.id
# }

# resource "aws_vpc_endpoint" "app_vpc_s3_endpoint" {
#     vpc_id            = aws_vpc.app_vpc.id
#     service_name      = "com.amazonaws.${var.aws_region}.s3"
#     vpc_endpoint_type = "Gateway"
#     route_table_ids   = [aws_route_table.app_vpc_private_rt.id]
#     tags = {
#         Name        = "${var.vpc_name}-s3-endpoint"
#         Environment = var.environment
#     }
# }