
### Lets begin by refactoring our code into modules

### I created a folder called modules
```
mkdir modules
```

Then change directory to the module directory

```
cd modules
```
### inside the module directory, I created the following files to keep our code well structured and modular
- VPC     For networking   NAT gateway (nat-gw.tf), Internet Gateway(internet-gw.tf), Routes (routes.tf), Roles (roles.tf), main,tf with the vpc and subnets(main.tf)
- ALB     For Load balancer resources
- AS  For Autoscaling and launch template resources
- EFS   For Elastic File System resources
- RDS    For Database
- COMPUTE   For EC2 and related resources
- SECURITY For security group resources

### I moved network files to modules/VPC
```
mv internet-gw.tf nat-gw.tf main.tf roles.tf routes.tf modules/VPC
```

### I moved rds.tf to modules/RDS
```
mv rds.tf modules/RDS
```
### Next I moved alb.tf , cert.tf, output.tf to modules/ALB
```
mv alb.tf certificate.tf output.tf modules/ALB
```
### I moved efs.tf to modules/EFS
```
mv efs.tf modules/EFS
```
### Then i moved sg.tf to modules/SECURITY
```
mv sg.tf modules/SECURITY
```
### Next I moved mv asg-bastion-nginx.tf asg-webserver.tf bastion.sh nginx.sh tooling.sh wordpress.sh to modules/ASG
```
mv asg-bastion-nginx.tf asg-webserver.tf bastion.sh nginx.sh tooling.sh wordpress.sh modules/ASG
```

### In the root, we create providers.tf and cut the provider function from the former main.tf now in modules/VPC/main.tf

```
touch providers.fs
```
### paste the snippet below into it

```
provider "aws" {
  region = var.region
}
```

### Each module must have a variables.tf file
```
cd modules/VPC && touch variables.tf 
cd modules/ALB && touch variables.tf
cd modules/COMPUTE && touch variables.tf
cd modules/EFS && touch variables.tf
cd modules/RDS && touch variables.tf
cd modules/SECURITY && touch variables.tf
cd modules/ASG && touch variables.tf
```
### Variables.tf successfuly created in all modules

### Each module must have a main.tf file
```
cd modules/VPC && touch main.tf 
cd modules/ALB && touch main.tf
cd modules/COMPUTE && touch main.tf
cd modules/EFS && touch main.tf
cd modules/RDS && touch main.tf
cd modules/SECURITY && touch mains.tf
cd modules/ASG && touch main.tf
```
### Variables.tf successfuly created in all modules

### Each module must have a output.tf file
```
cd modules/VPC && touch output.tf 
cd modules/ALB && touch output.tf
cd modules/COMPUTE && touch output.tf
cd modules/EFS && touch output.tf
cd modules/RDS && touch output.tf
cd modules/SECURITY && touch output.tf
cd modules/ASG && touch output.tf
```
### Variables.tf successfuly created in all modules
# In module/ALB
### In alb.tf some hard coding was substituted with variables
```
# We need to create an ALB to balance the traffic between the Instances:

resource "aws_lb" "ext-alb" {
  name     = var.name
  internal = false
  security_groups = [var.public-sg]

  subnets = [var.public-sbn-1, var.public-sbn-2]
   tags = merge(
    var.tags,
    {
      Name = var.name
    },
  )

  ip_address_type    = var.ip_address_type
  load_balancer_type = var.load_balancer_type
}

# We need to inform the ALB of where where route the traffic.  We need to create a Target Group for our load balancer
# Create the target group
# The targets are our nginx reverse proxy servers

resource "aws_lb_target_group" "nginx-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name        = "nginx-tgt"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = var.vpc_id
}


# Next, we will create a Listner for the target group aws_lb_target_group.nginx-tgt

resource "aws_lb_listener" "nginx-listner" {
  load_balancer_arn = aws_lb.ext-alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.workachoo.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-tgt.arn
  }
}


# Next step is to create an Internal (Internal) Application Load Balancer (ALB)


# ----------------------------
#Internal Load Balancers for webservers
#---------------------------------

resource "aws_lb" "ialb" {
  name     = "ialb"
  internal = true
  security_groups = [var.private-sg]

  subnets = [
    var.private-sbn-1,
    var.private-sbn-2,
  ]

  tags = merge(
    var.tags,
    {
      Name = "ACS-int-alb"
    },
  )

  ip_address_type    = var.ip_address_type
  load_balancer_type = var.load_balancer_type
}
# To inform our ALB to where route the traffic we need to create a Target Group to point to its targets:

# --- target group  for wordpress -------

resource "aws_lb_target_group" "wordpress-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "wordpress-tgt"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

# --- target group for tooling -------

resource "aws_lb_target_group" "tooling-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "tooling-tgt"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = var.vpc_id
}
# Then we will need to create a Listener for this target Group

# For this aspect a single listener was created for the wordpress which is default,
# A rule was created to route traffic to tooling when the host header changes

resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.ialb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.workachoo.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tgt.arn
  }
}


# listener rule for tooling target

resource "aws_lb_listener_rule" "tooling-listener" {
  listener_arn = aws_lb_listener.web-listener.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tooling-tgt.arn
  }

  condition {
    host_header {
      values = ["tooling.workachoo.com"]
    }
  }
}
```
### In modules/ALB/variables.tf
```
# The security froup for external loadbalancer
variable "public-sg" {
  description = "Security group for external load balancer"
}


# The public subnet froup for external loadbalancer
variable "public-sbn-1" {
  description = "Public subnets to deploy external ALB"
}
variable "public-sbn-2" {
  description = "Public subnets to deploy external  ALB"
}


variable "vpc_id" {
  type        = string
  description = "The vpc ID"
}


variable "private-sg" {
  description = "Security group for Internal Load Balance"
}

variable "private-sbn-1" {
  description = "Private subnets to deploy Internal ALB"
}
variable "private-sbn-2" {
  description = "Private subnets to deploy Internal ALB"
}

variable "ip_address_type" {
  type        = string
  description = "IP address for the ALB"

}

variable "load_balancer_type" {
  type        = string
  description = "te type of Load Balancer"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}


variable "name" {
    type = string
    description = "name of the loadbalancer"
  
}
```
### output.tf
```
# I addedd the following outputs to output.tf to print them on screen

output "alb_dns_name" {
  value = aws_lb.ext-alb.dns_name
}

output "lb_target_group_arn" {
  value = aws_lb_target_group.nginx-tgt.arn
}

output "nginx-tgt" {
  description = "External Load balancaer target group"
  value       = aws_lb_target_group.nginx-tgt.arn
}


output "wordpress-tgt" {
  description = "wordpress target group"
  value       = aws_lb_target_group.wordpress-tgt.arn
}


output "tooling-tgt" {
  description = "Tooling target group"
  value       = aws_lb_target_group.tooling-tgt.arn
}
```