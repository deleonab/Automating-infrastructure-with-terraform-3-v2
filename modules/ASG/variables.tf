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