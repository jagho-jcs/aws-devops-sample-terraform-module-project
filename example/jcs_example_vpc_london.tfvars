#######################################
#
# Environment Variables
#
#######################################

region                       = "eu-west-2"

# shared_credentials_file      = "/../../.aws/credentials"

# profile                      = "dev-jcs"

name                         = "jcs-demo-tfvars"

cidr                         = "32.128.0.0/16"

azs                          = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]

private_subnets              = ["32.128.16.0/20", "32.128.32.0/20", "32.128.48.0/20"]

public_subnets               = ["32.128.112.0/20", "32.128.128.0/20", "32.128.144.0/20"]

#######################################
#
# Tags
#
#######################################

environment_tag              = "Demo"

vpc_tags                     = { DataCenter = "N. Virginia", DeployedBy = "Yomi Ogunyinka" }

#######################################
#
#  Web Cluster Configuration
#
#######################################

web_cluster_tag              = "web_cluster"

key_name                     = "hsbc_demo_web_cluster"

public_key_path              = "~/.ssh/id_rsa.pub"

private_key_path             = "~/.ssh/id_rsa"

instance_type                = "t2.micro"

#######################################
#
#  Autoscaling  Configuration
#
#######################################

desired_capacity             = 1
min_size                     = 1
max_size                     = 1

#######################################
#
#  Application load balancer  Configuration
#
#######################################

aws_alb_tgt_grp_att_port     = 8080
aws_alb_target_group_port    = 8080
aws_alb_listener_port        = 80