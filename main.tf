#################################################[ SECURITY GROUP ]###############################################
resource "aws_security_group" "sg" {
    vpc_id      = var.vpc-id
    name        = var.sg_name
    description = "Security Group for server"

    dynamic "ingress" {
        for_each = var.inbound_ports
        content {
            from_port   = ingress.value.port
            to_port     = ingress.value.port
            protocol    = var.sg_protocol
            cidr_blocks = var.sg_cidr
        }
    }

    dynamic "egress" {
        for_each = var.outbound_ports
        content {
            from_port   = egress.value.port
            to_port     = egress.value.port
            protocol    = var.sg_egress_protocol
            cidr_blocks = var.sg_cidr
        }
    }
}

#################################################[ Template ]###############################################
resource "aws_launch_template" "template" {
  name = var.template_name

  block_device_mappings {
    device_name = var.block_map

    ebs {
      volume_size = var.ebs_vol
    }
  }

  image_id        = var.ami_image
  instance_type   = var.inst_type
  key_name        = var.key

  placement {
    availability_zone = var.AZ
  }

  vpc_security_group_ids = [aws_security_group.sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.temp_tag
    }
  }
}

################################################[Target Group]###########################################
resource "aws_lb_target_group" "target_group" {
  name        = var.tg-name
  port        = var.port_num
  protocol    = var.tg_protocol
  target_type = var.tg_target
  vpc_id      = var.vpc-id
}

################################################[Load Balancer]###########################################
resource "aws_lb" "loadbalancer" {
  name                      = var.lb-name
  internal                  = var.lb-internal == "true" ? true : false
  load_balancer_type        = var.lb-type
  security_groups           = [aws_security_group.sg.id]
  subnets                   = var.lb-subs
  enable_deletion_protection = false
}

####################################[Load Balancer Listener Rule]########################################################
resource "aws_lb_listener" "employee" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = var.lb-port
  protocol          = var.lb-protocol
  default_action {
    type             = var.lb-action-type
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

#################################################[ Autoscaling Group  ]###############################################
resource "aws_autoscaling_group" "autoscale" {
  depends_on = [aws_lb.loadbalancer]
  name                  = var.asg-name  
  availability_zones    = var.asg-azs
  desired_capacity      = var.desired
  max_size              = var.max
  min_size              = var.min
  health_check_type     = var.asg-health-type
  termination_policies  = var.term-policies

  launch_template {
    id      = aws_launch_template.template.id
    version = var.temp-version
  }
}

resource "aws_autoscaling_policy" "avg_cpu_policy_greater" {
  name                   = var.asg-policy
  policy_type            = var.asg-policy-type
  autoscaling_group_name = aws_autoscaling_group.autoscale.id
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.asg-metric
    }
    target_value = var.asg-metric-target
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.autoscale.id
  lb_target_group_arn    = aws_lb_target_group.target_group.arn
}
