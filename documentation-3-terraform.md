
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
- ALB     For Load balancer
- AS  For Autoscaling groups
- EFS   For Elastic File System
- RDS    For Database
- COMPUTE   For compute
- SECURITY For security groups

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
touch 
touch
touch
touch
touch
touch
```
