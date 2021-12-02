data "aws_ami" "ami-amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Bastion host security group
resource "aws_security_group" "bastion_sg" {
  name        = "VPC-${var.vpc_env}-Bastion-SG"
  description = "Bastion Security Group"
  vpc_id      = var.vpc_id

  ingress = []

  egress = [
    {
      description = "all outbound is permitted"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = null
    }
  ]

  tags = merge(
    var.default_tags,
    {
      Name = "VPC-${var.vpc_env}-Bastion-SG"
      Environment = "${var.vpc_env}"
    }
  )
}

# public ssh ingress to Bastion only in Shared env
resource "aws_security_group_rule" "ssh_public" {
  security_group_id = aws_security_group.bastion_sg.id
  count = (var.vpc_env == "Shared") ? 1 : 0
  type = "ingress"
  description = "ssh access to Bastion from the internet"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Bastion host instance
module "bastion_host" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                        = "VPC-${var.vpc_env}-Bastion"
  ami                         = data.aws_ami.ami-amzn2.id
  instance_type               = "t2.micro"
  key_name                    = "${var.default_tags["Project"]}admin"
  monitoring                  = true
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  subnet_id                   = var.public_subnets[0].id
  associate_public_ip_address = true
  iam_instance_profile        = "LabInstanceProfile"
  
  tags = merge(
    var.default_tags,
    {
      Name = "VPC-${var.vpc_env}-Bastion"
      Environment = "${var.vpc_env}"
    }
  )
}
