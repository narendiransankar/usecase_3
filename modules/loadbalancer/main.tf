resource "aws_lb" "alb" {
  name               = "path-based-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_ids

  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "tg_homepage" {
  name        = "homepage-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
resource "aws_lb_target_group_attachment" "tg_homepage_attachment" {
  target_group_arn = aws_lb_target_group.tg_homepage.arn
  target_id        = var.instance_a_id
  port             = 80
 
}

resource "aws_lb_target_group" "tg_images" {
  name        = "images-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/images/index.html"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "tg_images_attachment" {
  target_group_arn = aws_lb_target_group.tg_images.arn
  target_id        = var.instance_b_id
  port             = 80
 
}




resource "aws_lb_target_group" "tg_register" {
  name        = "register-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/register/index.html"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
resource "aws_lb_target_group_attachment" "tg_register_attachment" {
  target_group_arn = aws_lb_target_group.tg_register.arn
  target_id        = var.instance_c_id
  port             = 80

}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_homepage.arn
  }
}

resource "aws_lb_listener_rule" "rule_images" {
  listener_arn = aws_lb_listener.listener_http.arn

  condition {
    path_pattern {
      values = ["/images/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_images.arn
  }
}

resource "aws_lb_listener_rule" "rule_register" {
  listener_arn = aws_lb_listener.listener_http.arn

  condition {
    path_pattern {
      values = ["/register/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_register.arn
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "dev"
  }
}



