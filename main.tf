# Define a variable for the desired instance count
variable "instance_count" {
  description = "Number of instances to launch"
  default     = 2
}

provider "aws" {
  region = "us-east-1"  # Replace with your region
}

variable "ami_id" {
   description = "default AMI"
   default     = "ami-06b21ccaeff8cd686"  # Replace with the desired AMI ID
}

# Launch Template for the Auto Scaling Group
resource "aws_launch_template" "example" {
  name          = "example-lt"
  image_id      = var.ami_id
  instance_type = "t2.micro"

  # Optionally specify the key pair, security groups, or other configurations
  # key_name      = "your-key-name"
  # security_group_names = ["sg-xxxxxx"]

  # You can specify user data here if needed
  # user_data = base64encode(file("user_data.sh"))

  tags = {
    Name = "launch-template-example"
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "example" {
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  min_size         = 1
  max_size         = 5
  desired_capacity = var.instance_count
  vpc_zone_identifier = ["subnet-0ef2900825d9fd537"]  # Replace with your subnet ID

  tag {
    key                 = "Name"
    value               = "autoscaling-example"
    propagate_at_launch = true
  }
}

# Query EC2 instances by Auto Scaling Group tags
data "aws_instances" "example" {
  filter {
    name   = "tag:Name"
    values = ["autoscaling-example"]
  }
}

# Output the public IPs of the instances
output "instance_public_ips" {
  value = data.aws_instances.example.public_ips
}
