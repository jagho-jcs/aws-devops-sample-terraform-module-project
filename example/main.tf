data "aws_availability_zones" "all" {}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "../"

  name                       = var.name
  
  cidr                       = var.cidr

  azs                        = var.azs
  
  public_subnets             = var.public_subnets

  private_subnets            = var.private_subnets

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-name"
  }

}