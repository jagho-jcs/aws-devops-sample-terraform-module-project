# variable "region" {
#   type = "string"
#   description = "describe your variable"
# }

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "name" {
  type = "string"
  description = "describe your variable"
  default     = ""
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "azs" {
  type = list(string)
  description = "describe your variable"
  default = []
}

variable "public_subnets" {
  type = list(string)
  description = "describe your variable"
  default  = []
}

variable "private_subnets" {
  type = list(string)
  description = "describe your variable"
  default  = []
}


variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_classiclink" {
  description = "Should be true to enable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = null
}

variable "enable_classiclink_dns_support" {
  description = "Should be true to enable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = null
}
###########################################################################
#
#   Tags
#
###########################################################################

variable "environment_tag" {
  type = "string"
  description = "describe your variable"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {

                  ProvisionedBy = "Terraform"
                
                }
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

# variable "igw_tags" {
#   description = "Additional tags for the internet gateway"
#   type        = map(string)
#   default     = {}
# }

variable "igw_tag" {
  description = "tag for the internet gateway"
  type        = string
  default     = "igw"
}

variable "public_acl_tag" {
  description = "tag for the public subnets network ACL"
  type        = string
  default     = "ACLS Public"
}

variable "private_acl_tag" {
  description = "tag for the private subnets network ACL"
  type        = string
  default     = "ACLS Private"
}

variable "public_subnet_tag" {
  description = "tag for the public subnets"
  type        = string
  default     = "Public Subnet"
}

variable "private_subnet_tag" {
  description = "tag for the private subnets"
  type        = string
  default     = "Private Subnet"
}

variable "public_route_table_tag" {
  description = "tag for the public route tables"
  type        = string
  default     = "Public Route Table"
}

variable "private_route_table_tag" {
  description = "tag for the private route tables"
  type        = string
  default     = "Private Route Table"
}

variable "demo_env_default_tags" {
  type        = map(string)
  description = "Default tags to be applied to all resources created in the demo environment"
  default = {
    ConsultantName = "Yomi Ogunyinka"
    Position       = "Solutions Architect"
    ProvisionedBy  = "Terraform"
    Location       = "Ireland"
    DataCenter     = "New Business"
    Team           = "DevOps"
    CostCentre     = "Operations"
  }
}
variable "security_groups_tags" {
  type        = map(string)
  description = "Default tags to be applied to all resources created in the demo environment"
  default = {
    Application  = "NGINX-Spring-Boot-App"
  }
}

variable "web_cluster_tag" {
  type = "string"
  description = "describe your variable"
}


variable "key_name" {
  type              = "string"
  description       = "describe your variable"
}

variable "public_key_path" {
  type = "string"
  description = "describe your variable"
}

variable "private_key_path" {
  type = "string"
  description = "describe your variable"
}

variable "instance_type" {
  type = "string"
  description       = "describe your variable"
}

variable "desired_capacity" {
  type = "string"
  description = "describe your variable"

  # default           = 3
}

variable "min_size" {
  type = "string"
  description = "describe your variable"

  # default           = 2
}

variable "max_size" {
  type = "string"
  description = "describe your variable"

  # default           = 6
}

variable "aws_alb_tgt_grp_att_port" {
  type = "string"
  description = "describe your variable"

  # default           = 8080
}

variable "aws_alb_target_group_port" {
  type = "string"
  description = "describe your variable"

  # default           = 8080
}

variable "aws_alb_listener_port" {
  type = "string"
  description = "describe your variable"

  # default           = 80
}

###########################################################################
#
#   Default VPC Configuration - 
#
###########################################################################

variable "manage_default_vpc" {
  description = "Should be true to adopt and manage Default VPC"
  type        = bool
  default     = true
}

variable "default_vpc_name" {
  description = "Name to be used on the Default VPC"
  type        = string
  default     = "do not use - terraform!.."
}

variable "default_vpc_enable_dns_support" {
  description = "Should be true to enable DNS support in the Default VPC"
  type        = bool
  default     = true
}

variable "default_vpc_enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the Default VPC"
  type        = bool
  default     = false
}

variable "default_vpc_enable_classiclink" {
  description = "Should be true to enable ClassicLink in the Default VPC"
  type        = bool
  default     = false
}

variable "default_vpc_tags" {
  description = "Additional tags for the Default VPC"
  type        = map(string)
  default     = {

    ProvisionedBy = "Amazon Web Services"
  }
}

