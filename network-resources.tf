

# Create a VPC
resource "aws_vpc" "Jana_vpc" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "Jana_vpc"
    }
}

# Create a public subnet 1
resource "aws_subnet" "three-tier-pub-sub-1"{
    vpc_id = aws_vpc.Jana_vpc.id
    cidr_block = "10.0.0.0/28"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "three-tier-pub-sub-1"
    }
}

# Create a public subnet 2
resource "aws_subnet" "three-tier-pub-sub-2"{
    vpc_id = aws_vpc.Jana_vpc.id
    cidr_block = "10.0.0.16/28"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
      Name = "three-tier-pub-sub-2"
    }
}

# create a private subnet 1
resource "aws_subnet" "three-tier-pvt-sub-1"{
    vpc_id = aws_vpc.Jana_vpc.id
    cidr_block = "10.0.0.32/28"
    availability_zone = "us-east-1a"
    tags = {
      Name = "three-tier-pvt-sub-1"
    }
}

# create a private subnet 2
resource "aws_subnet" "three-tier-pvt-sub-2"{
    vpc_id = aws_vpc.Jana_vpc.id
    cidr_block = "10.0.0.48/28"
    availability_zone = "us-east-1b"
    tags = {
      Name = "three-tier-pvt-sub-2"
    }
}

# create a private subnet 3
resource "aws_subnet" "three-tier-pvt-sub-3"{
    vpc_id = aws_vpc.Jana_vpc.id
    cidr_block = "10.0.0.64/28"
    availability_zone = "us-east-1a"
    tags = {
      Name = "three-tier-pvt-sub-3"
    }
}

# create a private subnet 4
resource "aws_subnet" "three-tier-pvt-sub-4"{
    vpc_id = aws_vpc.Jana_vpc.id
    cidr_block = "10.0.0.80/28"
    availability_zone = "us-east-1b"
    tags = {
      Name = "three-tier-pvt-sub-4"
    }
}

# Create an internet gateway
resource "aws_internet_gateway" "three-tier-igw"{
    vpc_id = aws_vpc.Jana_vpc.id
    tags = {
        Name = "three-tier-igw"
    }
}

# create a Nat gateway in the first public subnet
resource "aws_nat_gateway" "three-tier-natgw-01"{

    allocation_id = aws_eip.three-tier-nat-eip.id
    subnet_id = aws_subnet.three-tier-pub-sub-1.id

    tags = {
        Name = "three-tier-natgw-01"
    }
    depends_on = [ aws_internet_gateway.three-tier-igw ]
}

# create the web route table for public subnets
resource "aws_route_table" "three-tier-web-rt" {
    vpc_id = aws_vpc.Jana_vpc.id
    tags = {
        Name = "three-tier-pub-rt"
    }

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.three-tier-igw.id
  }
}

# create a app route table for private subnets
resource "aws_route_table" "three-tier-app-rt"{
    vpc_id = aws_vpc.Jana_vpc.id
    tags = {
        Name = "three-tier-app-rt"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.three-tier-natgw-01.id
    }
}

# Route table association for public subnet 1
resource "aws_route_table_association" "three-tier-rt-as-1" {
    subnet_id = aws_subnet.three-tier-pub-sub-1.id
    route_table_id = aws_route_table.three-tier-web-rt.id
}

# Route table association for public subnet 2
resource "aws_route_table_association" "three-tier-rt-as-2" {
    subnet_id = aws_subnet.three-tier-pub-sub-2.id
    route_table_id = aws_route_table.three-tier-web-rt.id
}

# Route table association for private subnet 1
resource "aws_route_table_association" "three-tier-rt-as-3" {
    subnet_id = aws_subnet.three-tier-pvt-sub-1.id
    route_table_id = aws_route_table.three-tier-app-rt.id
}
# Route table association for private subnet 2
resource "aws_route_table_association" "three-tier-rt-as-4" {
    subnet_id = aws_subnet.three-tier-pvt-sub-2.id
    route_table_id = aws_route_table.three-tier-app-rt.id
}
# Route table association for private subnet 3
resource "aws_route_table_association" "three-tier-rt-as-5" {
    subnet_id = aws_subnet.three-tier-pvt-sub-3.id
    route_table_id = aws_route_table.three-tier-app-rt.id
}
# Route table association for private subnet 4
resource "aws_route_table_association" "three-tier-rt-as-6" {
    subnet_id = aws_subnet.three-tier-pvt-sub-4.id
    route_table_id = aws_route_table.three-tier-app-rt.id
}

# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "three-tier-nat-eip" {
    vpc = true
    tags = {
        Name = "three-tier-nat-eip"
    }
}

# Create a Load Balancer in the public subnet for web servers
resource "aws_lb" "three-tier-web-lb"{
    name               = "three-tier-web-lb"
    internal           = false
    load_balancer_type = "application"

    security_groups = [aws_security_group.three-tier-alb-sg-1.id]
    subnets = [aws_subnet.three-tier-pub-sub-1.id, aws_subnet.three-tier-pub-sub-2.id]

    tags = {
    Environment = "three-tier-web-lb"
  }
}

# create a load balancer for application servers in private subnets
resource "aws_lb" "three-tier-app-lb"{
    name ="three-tier-app-lb"
    internal = true
    load_balancer_type = "application"

    security_groups = [aws_security_group.three-tier-alb-sg-2.id]
    subnets = [aws_subnet.three-tier-pvt-sub-1.id, aws_subnet.three-tier-pvt-sub-2.id]

    tags = {
        Environment = "three-tier-app-lb"
    }
}

# Create a target group for the web servers
resource "aws_lb_target_group" "three-tier-web-lb-tg"{
    name     = "three-tier-web-lb-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.Jana_vpc.id
}

# Create a target group for the application servers
resource "aws_lb_target_group" "three-tier-app-lb-tg"{
    name     = "three-tier-app-lb-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.Jana_vpc.id
}

# Create Load Balancer listener - web tier
resource "aws_lb_listener" "three-tier-web-lb-listner"{
    load_balancer_arn = aws_lb.three-tier-web-lb.arn
    port             = 80
    protocol         = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.three-tier-web-lb-tg.arn
    }
}

## Create Load Balancer listener - app tier
resource "aws_lb_listener" "three-tier-app-lb-listner" {
  load_balancer_arn = aws_lb.three-tier-app-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.three-tier-app-lb-tg.arn
  }
}

# Register the instances with the target group - web tier
resource "aws_autoscaling_attachment" "three-tier-web-asattach" {
  autoscaling_group_name = aws_autoscaling_group.three-tier-web-asg.name
  lb_target_group_arn    = aws_lb_target_group.three-tier-web-lb-tg.arn
  
}

# Register the instances with the target group - app tier
resource "aws_autoscaling_attachment" "three-tier-app-asattach" {
  autoscaling_group_name = aws_autoscaling_group.three-tier-app-asg.name
  lb_target_group_arn   = aws_lb_target_group.three-tier-app-lb-tg.arn
  
}





