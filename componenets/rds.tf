resource "aws_db_subnet_group" "eks_rds_db_subnetgroup" {
    name       = var.eks_rds_db_subnetgroup_name
    description = "EKS RDS DB Subnet Group"
    subnet_ids = [aws_subnet.app_vpc_private_subnets.id, aws_subnet.app_vpc_private_subnets_2.id]

    tags = {
        Name = var.eks_rds_db_subnetgroup_name
    }
}

resource "aws_db_instance" "usermgmtdb" {
    identifier     = var.rds_db_instance_identifier
    engine         = var.rds_db_engine_name
    # engine_version = var.rds_db_engine_version
    instance_class = var.rds_db_instance_class
    allocated_storage = var.rds_db_allocated_storage
    
    db_name  = var.rds_db_name
    username = var.rds_db_username
    password = var.rds_db_password
    
    vpc_security_group_ids = [aws_security_group.eks_rds_db_sg.id]
    db_subnet_group_name   = aws_db_subnet_group.eks_rds_db_subnetgroup.name
    
    publicly_accessible = true
    port                = 3306
    
    skip_final_snapshot = true
    
    tags = {
        Name = var.rds_db_instance_identifier
    }
}