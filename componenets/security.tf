resource "aws_security_group" "app_vpc_public_sg" {
    name        = "${var.vpc_name}-${var.public_security_group_name}"
    description = "Allow SSH, HTTP, HTTPS from anywhere"
    vpc_id      = aws_vpc.app_vpc.id

    ingress {
        description      = "SSH"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
        description      = "HTTP"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
        description      = "HTTPS"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
        description      = "Allow ICMP (ping) from anywhere"
        from_port        = -1
        to_port          = -1
        protocol         = "icmp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
        description      = "Allow all traffic from anywhere"
        from_port        = 0
        to_port          = 65535
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "app_vpc_private_sg" {
    name        = "${var.vpc_name}-${var.private_security_group_name}"
    description = "Permit SSH only from public-sg"
    vpc_id      = aws_vpc.app_vpc.id

    ingress {
        description      = "SSH from public-sg"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        security_groups  = [aws_security_group.app_vpc_public_sg.id]
    }

    ingress {
        description      = "Allow ICMP (ping) from public-sg"
        from_port        = -1
        to_port          = -1
        protocol         = "icmp"
        security_groups  = [aws_security_group.app_vpc_public_sg.id]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}