resource "aws_lb" "main" {
  name               = format("%s-alb", local.stack_identifier)
  internal           = true
  idle_timeout       = var.api_timeout
  load_balancer_type = "application"
  security_groups    = var.internal_security_groups
  subnets            = var.private_subnet_ids

  access_logs {
    bucket  = aws_s3_bucket.access_logs.id
    enabled = var.enable_alb_access_logs
  }

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-alb", local.stack_identifier),
      ResourceType : "load-balancer",
    }
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
