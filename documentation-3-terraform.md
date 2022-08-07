
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