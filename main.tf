terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.6"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "aws_iam_role" "ecr" {
  name = "LabRole"
}

# create VPC and subnets for the environment
module "networking" {
  for_each = local.vpc_envs

  source        = "./VPC"
  vpc_env       = each.key
  vpc_cidr      = each.value.vpc_cidr
  public_cidrs  = each.value.public_cidrs
  private_cidrs = each.value.private_cidrs
  counter       = length(each.value.public_cidrs)
}

# add bastion host to VPC 
module "servers" {
  for_each = local.vpc_envs

  source          = "./EC2"
  vpc_env         = each.key
  vpc_id          = module.networking[each.key].vpc_id
  public_subnets  = module.networking[each.key].public_subnets
  private_subnets = module.networking[each.key].private_subnets
}

# aws ecr repo to store docker images
module "ecr" {
  source                 = "cloudposse/ecr/aws"
  namespace              = "lab3"
  stage                  = "shared"
  name                   = "catsdogs"
  principals_full_access = [data.aws_iam_role.ecr.arn]
}
