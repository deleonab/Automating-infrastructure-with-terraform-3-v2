
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

## In modules/ALB/output.tf
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