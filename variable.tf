#################################################[ Provider ]###############################################

variable "aws_region" {
  type    = string
  default = "us-east-1"
  description = "aws region"
}

#################################################[ VPC ]###############################################

variable "instance_tenancy" {
  type    = string
  default = "default"
  description = "it determines whether instances launched in the VPC will share hardware with instances from other AWS accounts (default tenancy) "
}

variable "cidr" {
  type    = string
  default = "172.31.0.0/16"
  description = "Cidr range of Dev vpc"
}

variable "vpc_name" {
  type    = string
  default = "Dev"
}

#################################################[ SECURITY GROUP ]###############################################

variable "vpc-id" {
  description = "vpc_id"
  type        = string
  default     = "vpc-0ee05b4dec92fbd9a"
}


variable "sg_name" {
  description = "Name of the Security Group"
  type        = string
  default     = "employee_sg"
}


variable "sg_protocol" {
  description = "Protocol for Security Group rules"
  type        = string
  default     = "tcp"
}

variable "sg_egress_protocol" {
  description = "Protocol for Security Group rules"
  type        = string
  default     = "-1"
}
variable "sg_cidr" {
  description = "CIDR blocks for ingress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "inbound_ports" {
  description = "List of inbound ports for ingress rules"
  type        = list(object({
    port = number
  }))
  default = [
    { port = 80 },
    { port = 8080 },
    { port = 6379},
    { port = 5342 },
    { port = 443 }
  ]
}

variable "outbound_ports" {
  description = "List of outbound ports for egress rules"
  type        = list(object({
    port = number
  }))
  default = [
    { port = 0 }
  ]
}
#################################################[ Launch Template ]###############################################


variable "template_name" {
  description = "template name"
  type        = string
  default     = "employee_temp"
}

variable "block_map" {
  description = "Block device maapping"
  type        = string
  default     = "/dev/sdf"
}


variable "ebs_vol" {
  description = "template name"
  type        = number
  default     = 20
}


variable "ami_image" {
  description = "Ami id"
  type        = string
  default     = "ami-04be4c750a1466451"
}

variable "inst_type" {
  description = "instance type"
  type        = string
  default     = "t2.small"
}
variable "key" {
  description = "key name"
  type        = string
  default     = "p8-dev-infra"
}

variable "AZ" {
  description = "availabilty zone"
  type        = string
  default     = "us-east-1e"
}

variable "temp_tag" {
  description = "Tag name fortemplate"
  type        = string
  default     = "employee_template"
}




#################################################[ Target Group Name ]###############################################

variable "tg-name" {
  description = "Target group name"
  type        = string
  default     = "employee-tg"
}
variable "port_num" {
  description = "Port number for target group"
  type        = number
  default     = 8080
}
variable "tg_protocol" {
  description = "Target group protocol"
  type        = string
  default     = "HTTP"
}
variable "tg_target" {
  description = "Target type"
  type        = string
  default     = "instance"
}
############################################# [ Load Balancer]###########################################



variable "lb-name" {
  description = "load balancer name"
  type        = string
  default     = "employee-lb"
}

variable "lb-internal" {
  description = "internal load balancer option"
  type        = string
  default     = "false"
}
variable "lb-type" {
  description = "load balancer typ"
  type        = string
  default     = "application"
}

variable "lb-subs" {
  description = "load balancer subnets id"
  type        = list(string)
  default     = ["subnet-0fe713090a9174592","subnet-0d4945ae1610a4b46" ,"subnet-008c7701a750b048f"]

}

#################################################[  Loadbalancer listner Rule ]###############################################

variable "lb-port" {
  description = "load balancer target port"
  type        = number
  default     = 8080
}

variable "lb-protocol" {
  description = "load balancer port protocol"
  type        = string
  default     = "HTTP"
}

variable "lb-action-type" {
  description = "forwarding request on 8080"
  type        = string
  default     = "forward"
}

#################################################[ Auto Scaling Group ]###############################################

variable "asg-name" {
  description = "Name of auto scaling group"
  type        = string
  default     = "employee_asg"
}

variable "asg-azs" {
  description = "autoscaling availability Zones"
  type        = list(string)
  default     = ["us-east-1d", "us-east-1c", "us-east-1f"]
}

variable "desired" {
  description = "desired capacity of instances"
  type        = number
  default     = 1
}

variable "min" {
  description = "minimum capacity of instances"
  type        = number
  default     = 1
}

variable "max" {
  description = "maximum capacity of instances"
  type        = number
  default     = 2
}

variable "asg-health-type" {
  description = "health check type for ASG"
  type        = string
  default     = "ELB"
}

variable "term-policies" {
  description = "termination policies"
  type        = list(string)
  default     = ["OldestInstance"]
}

variable "temp-version" {
  description = "Template version"
  type        = string
  default     = "$Latest"
}

#########################################[ASG Policies]###############################################

variable "asg-policy" {
  description = "Name of asg policy"
  type        = string
  default     = "employee_asg_policy"
}

variable "asg-policy-type" {
  description = "Type of asg policy"
  type        = string
  default     = "TargetTrackingScaling"
}

variable "asg-metric" {
  description = "Metric type"
  type        = string
  default     = "ASGAverageCPUUtilization"
}

variable "asg-metric-target" {
  description = "target value for metric"
  type        = number
  default     = 50.0
}
