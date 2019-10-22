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