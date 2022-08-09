variable "max_size" {
  type        = number
  description = "maximum number for autoscaling"
}

variable "min_size" {
  type        = number
  description = "minimum number for autoscaling"
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of instance in autoscaling group"

}
variable "keypair" {
  type        = string
  description = "Keypair for instances"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "public_subnets" {
  type = list
  description = "Seconf subnet for ecternal ALB"
}
variable "tooling-alb-tgt" {
  type        = string
  description = "tooling target group"
}

variable "wordpress-alb-tgt" {
  type        = string
  description = "wordpress target group"
}

variable "nginx-alb-tgt" {
  type        = string
  description = "nginx reverse proxy target group"
}

variable "ami-bastion" {
  type        = string
  description = "ami for bastion"
}

variable "ami-web" {
  type        = string
  description = "ami for webservers"
}

variable "instance_profile" {
  type        = string
  description = "Instance profile for launch template"
}

variable "bastion-sg" {
  type = list
  description = "security group for bastion"
}

variable "nginx-sg" {
  type = list
  description = "security group for nginx"
}

variable "web-sg" {
  type = list
  description = "security group for webservers"
}

variable "ami-nginx" {
  type        = string
  description = "ami for nginx"
}

variable "private_subnets" {
  type = list
  description = "first private subnets for internal ALB"
}