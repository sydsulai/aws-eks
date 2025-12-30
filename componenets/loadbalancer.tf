resource "aws_lb" "eks_nlb" {
  name               = var.network_loadbalancer_name
  internal           = false
  load_balancer_type = var.network_loadbalancer_type
  subnets            = [aws_subnet.app_vpc_public_subnets.id, aws_subnet.app_vpc_private_subnets_2.id]

  enable_deletion_protection = false

  tags = merge(var.tags, {
    "elbv2.k8s.aws/cluster" = "app-cluster-01"
  })
}