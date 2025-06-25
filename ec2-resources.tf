
## Create an EC2 auto scaling group for web subnet
resource "aws_autoscaling_group" "three-tier-web-asg" {
    name                      = "three-tier-web-asg"
    max_size                  = 3
    min_size                  = 2
    desired_capacity          = 2
    vpc_zone_identifier       = [aws_subnet.three-tier-pub-sub-1.id, aws_subnet.three-tier-pub-sub-2.id]
    
    launch_template {
        id = aws_launch_template.three-tier-web-lconfig.id
    }
}

## Create an EC2 auto scaling group for app subnet
resource "aws_autoscaling_group" "three-tier-app-asg" {
    name                      = "three-tier-app-asg"
    max_size                  = 3
    min_size                  = 2
    desired_capacity          = 2
    vpc_zone_identifier       = [aws_subnet.three-tier-pvt-sub-1.id, aws_subnet.three-tier-pvt-sub-2.id]
    
    launch_template {
      id = aws_launch_template.three-tier-app-lconfig.id
    }
}

## Create a launch configuration for web tier
resource "aws_launch_template" "three-tier-web-lconfig" {
    name_prefix                 = "three-tier-web-lconfig"
    image_id                    = "ami-09e6f87a47903347c"
    instance_type               = "t2.micro"
    key_name                    = "three-tier-web-asg-kp"
    vpc_security_group_ids      = [aws_security_group.three-tier-ec2-asg-sg.id]
    user_data                   = filebase64("install-apache.sh")
  
}


# Create a launch configuration for the EC2 instances
resource "aws_launch_template" "three-tier-app-lconfig" {
  name_prefix                 = "three-tier-app-lconfig"
  image_id                    = "ami-09e6f87a47903347c"
  instance_type               = "t2.micro"
  key_name                    = "three-tier-app-asg-kp"
  vpc_security_group_ids      = [aws_security_group.three-tier-ec2-asg-sg-app.id]
  user_data                   = filebase64("install-mssql.sh")
                                

}

