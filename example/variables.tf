#######################################
#
# Environment Variables
#
#######################################

variable "region" {}
variable "shared_credentials_file" {}
variable "profile" {}

#######################################

variable "name" {}
variable "cidr" {}
variable "azs" {}
variable "private_subnets" {}
variable "public_subnets" {}

#######################################
#
# Tags
#
#######################################

variable "environment_tag" {}
variable "vpc_tags" {}

#######################################
#
#  Web Cluster Configuration
#
#######################################

variable "web_cluster_tag" {}
variable "key_name" {}
variable "public_key_path" {}
variable "private_key_path" {}
variable "instance_type" {}

#######################################
#
#  Autoscaling  Configuration
#
#######################################

variable "desired_capacity" {}
variable "min_size" {}
variable "max_size" {}

#######################################
#
#  Application load balancer  Configuration
#
#######################################

variable "aws_alb_tgt_grp_att_port" {}
variable "aws_alb_target_group_port" {}
variable "aws_alb_listener_port" {}