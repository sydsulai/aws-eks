output "public_subnet_id" {
  value = aws_subnet.app_vpc_public_subnets.id
}

output "public_subnet_id_2" {
  value = aws_subnet.app_vpc_public_subnets_2.id
}

output "private_subnet_id" {
  value = aws_subnet.app_vpc_private_subnets.id
}

output "private_subnet_id_2" {
  value = aws_subnet.app_vpc_private_subnets_2.id
}

output "rds_db_endpoint" {
  value = aws_db_instance.usermgmtdb.endpoint
}