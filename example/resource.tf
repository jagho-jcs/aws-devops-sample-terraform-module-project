provider "aws" {
  region                      = "eu-west-1"
  shared_credentials_file     = "/../../.aws/credentials"
  profile                     = "dev-jcs"
}

data "aws_availability_zones" "all" {}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "../"

  name                       = "my-new-vpc"
  
  cidr                       = "172.128.0.0/16"

  azs                        = [ "eu-west-1a", "eu-west-1b" ]
  
  public_subnets             = ["172.128.112.0/20", "172.128.128.0/20", "172.128.144.0/20"]

  private_subnets            = ["172.128.16.0/20", "172.128.32.0/20", "172.128.48.0/20"]
}