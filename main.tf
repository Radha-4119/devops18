resource "aws_launch_configuration" "web_server_as" {
    image_id           = "ami-03972092c42e8c0ca"
    instance_type = "t2.micro"
    key_name = "Mypem.pem"
    security_groups = [aws_security_group.web_server.id]
}
   


  resource "aws_elb" "web_server_lb"{
     name = "web-server-lb"
     security_groups = [aws_security_group.web_server.id]
     subnets = ["subnet-0086d8abdf0cf04c8", "subnet-0febad72be1243e50"]
     listener {
      instance_port     = 8000
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
    tags = {
      Name = "terraform-elb"
    }
  }
resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    launch_configuration = aws_launch_configuration.web_server_as.name
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_lb.name]
    availability_zones    = ["us-east-1a", "us-east-1c"] 
    
  }

