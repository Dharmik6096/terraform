# Key Pair

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("terrakey-ec2.pub")
}

# Default VPC

resource "aws_default_vpc" "default" {

}

# Security Group

resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_default_vpc.default.id ## interpolation (Most omporatnt ask in interview )
  
  # Inbound Rules

  ingress {
    description = "SSH Open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP Open"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "automate-sg"
  }
}

resource "aws_instance" "server_1" {
  ami           = "ami-0fe18bc3cfa53a248"
  instance_type = "t3.micro"
}

# EC2 Instance

resource "aws_instance" "my_instance" {
  for_each = tomap({
    ec2-terraform-server1 = var.ec2_instance_type
    ec2-terrafrom-server2 = var.ec2_instance_type 
  })  # meta argument 

  depends_on = [ aws_security_group.my_security_group , aws_key_pair.deployer ]
  
  ami                    = var.ec2_ami_id
  instance_type          = each.value
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data              = file("install.sh")

  root_block_device {
    # volume_size = var.ec2_root_storage_size
    volume_size = var.env == "prd" ? 20 : var.ec2_root_storage_size 
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
  }
}


