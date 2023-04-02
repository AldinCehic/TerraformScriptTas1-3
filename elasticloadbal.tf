resource "aws_alb" "alb" {
  name               = "loadbalancer"
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.public_subnet1.id]
  security_groups    = [aws_security_group.allow_ssh.id, aws_security_group.my_security_group.id]
  load_balancer_type = "application"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

resource "aws_alb_target_group" "alb_tg" {
  name     = "loadbalancer-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_tg.arn
    type             = "forward"
  }
}



resource "aws_autoscaling_attachment" "nf" {
  autoscaling_group_name = aws_autoscaling_group.xl_asg.id
  lb_target_group_arn   = aws_alb_target_group.alb_tg.arn
}