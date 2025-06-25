# 3-tier-webapp-using-terraform
Host a Scalable, Reliable and Secure WordPress Application in 3 Tier Architecture on AWS using Terraform

## Introduction:
This project demonstrates building a highly available, scalable and secure 3 -tier web application using infrastructure as the code "Terraform". Solution consists of three layers web layer, app layer and database layer. In Web layer, we have hosted webapplication (frontend) in multiple availability zones for high availability and in the app layer, multiple EC2 instances are running which inturns connect to the database layer. In DB layer, we have hosted mysql db instance in primary AZ and have a standby instance in other AZ if primary fails. Whole solution is deployed inside the Virtual private cloud which has 2 public subnets contains web servers and 4 private subnet contains app servers and database.

## Architecture Overview:

![Terraform project](https://github.com/user-attachments/assets/a486ca4a-20e9-4d3f-823f-5a09eedd5fdd)


1. A Custom VPC with a multiple Public Subnet and Private Subnet across two Availability Zones.
2. EC2 Instances Across different Availability Zones used to run the web server and app servers in public & private subnets
3. EC2 Auto Scaling group for the scalability for the EC2 instances.
4. Relational Database Service(RDS) main and standby for storing the data deployed in private subnet across multiple availability Zones.
5. Application Load Balancer(ALB) for routing the traffic across Multiple AZs sitting in Public Subnet.
6. NAT Gateway deployed in public subnet acts as a proxy for the private instances to communicate with Internet.
7. EC2 Instance Connect to securely access the private instances.

## Terraform Creation:
1. database-resources.tf

*/ Contains the configuration for database resources in AWS
*/ Likely includes RDS or other database-related configurations

2. ec2-resources.tf

*/ Defines EC2 instances and auto-scaling configurations
*/ Contains launch templates for web and application tiers
*/ Configures Auto Scaling Groups (ASG) for both web and app tiers

3.install-apache.sh

*/ Shell script for installing and configuring Apache web server
*/ Used as user data in the web tier launch template

4. install-mssql.sh

*/ Shell script for installing and configuring Microsoft SQL Server
*/ Used as user data in the application tier launch template

5. network-resources.tf

*/ Contains networking configurations
*/ Likely includes VPC, subnet, and routing configurations

6. provider.tf

*/ Defines the AWS provider configuration
*/ Contains provider-specific settings and credentials configuration

7. securitygroup.tf

*/ Contains security group configurations
*/ Defines inbound and outbound traffic rules for the infrastructure

8. terraform.tfstate

*/ Terraform state file
*/ Keeps track of the current state of your infrastructure

9. terraform.tfstate.backup

*/ Backup of the Terraform state file
*/ Created automatically by Terraform for safety
