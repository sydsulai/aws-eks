# Standalone NLB for EKS Cluster
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

# Standalone NLB for EKS Target Group
resource "aws_lb_target_group" "eks_nlb_target_group" {
  name        = var.network_loadbalancer_target_group_name
  port        = var.network_loadbalancer_target_group_port
  protocol    = var.network_loadbalancer_target_group_protocol
  vpc_id      = aws_vpc.app_vpc.id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/usermgmt/health-status"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
    matcher             = "200-299"
  }

  tags = merge(var.tags, {
    "elbv2.k8s.aws/cluster" = "app-cluster-01"
  })
}

# Standalone NLB Listener
resource "aws_lb_listener" "eks_nlb_listener" {
  load_balancer_arn = aws_lb.eks_nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_nlb_target_group.arn
  }
}