data "aws_availability_zones" "all" {}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "../"

  name                       = var.name
  
#######################################
#
# Base Network
#
#######################################

  cidr                       = var.cidr
  azs                        = var.azs
  public_subnets             = var.public_subnets
  private_subnets            = var.private_subnets

#######################################
#
# Tags
#
#######################################

  vpc_tags                   = var.vpc_tags
  environment_tag            = var.environment_tag

#######################################
#
#  Web Cluster Configuration
#
#######################################

  web_cluster_tag            = var.web_cluster_tag
  key_name                   = var.key_name
  public_key_path            = var.public_key_path
  private_key_path           = var.private_key_path
  instance_type              = var.instance_type

#######################################
#
#  Autoscaling  Configuration
#
#######################################

  desired_capacity           = var.desired_capacity
  min_size                   = var.min_size
  max_size                   = var.max_size

#######################################
#
#  Application load balancer  Configuration
#
#######################################

  aws_alb_tgt_grp_att_port     = var.aws_alb_tgt_grp_att_port
  aws_alb_target_group_port    = var.aws_alb_target_group_port
  aws_alb_listener_port        = var.aws_alb_listener_port

}