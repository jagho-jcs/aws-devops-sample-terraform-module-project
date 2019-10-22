data "aws_availability_zones" "all" {}

###################
# VPC
###################

resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block                 = var.cidr
  enable_dns_support         = var.enable_dns_support
  enable_dns_hostnames       = var.enable_dns_hostnames

  tags = merge(
  {

    Name = var.name

    # "Name" = format("%", var.name)

    },
    var.tags,    # Will be applied to all resources
    var.vpc_tags,
    )
}

###################
# Internet Gateway
###################

resource "aws_internet_gateway" "default" {
  vpc_id                     = aws_vpc.this[0].id

  tags = merge(
  {

    "Name:" = "${var.igw_tags}_${var.name}"
  },
  var.tags,    # Will be applied to all resources
    # var.igw_tags,
  )
}

################
# Publiс routes
################

resource "aws_route_table" "public_rtb" {
  
  vpc_id                     = aws_vpc.this[0].id

  # tags = "${merge(var.demo_env_default_tags, map(
  #   "Name", "${var.vpc_tg} - ${var.public_rtb_tg}",
  #   "Environment", "${var.vpc_tg}",
  #   "Client", "JCS"
  #   ))}"
}

#######################################################
# Grant the VPC internet access on its main route table
#######################################################

resource "aws_route" "internet_access" {

  route_table_id             = "${aws_route_table.public_rtb.id}"
  destination_cidr_block     = "0.0.0.0/0"
  gateway_id                 = "${aws_internet_gateway.default.id}"

  timeouts {

            create           = "5m"
  }

}

#################
# Private routes
#################

resource "aws_route_table" "private_rtb" {
  vpc_id                     = aws_vpc.this[0].id

  # tags = "${merge(var.demo_env_default_tags, map(
  #   "Name", "${var.vpc_tg} - ${var.private_rtb_tg}",
  #   "Environment", "${var.vpc_tg}",
  #   "Client", "JCS"
  #   ))}"

  lifecycle {
    # When attaching VPN gateways it is common to define aws_vpn_gateway_route_propagation
    # resources that manipulate the attributes of the routing table (typically for the private subnets)
            ignore_changes   = [propagating_vgws]
  }
}

################
# Public subnet
################

resource "aws_subnet" "public" {


  count                      = "${length(data.aws_availability_zones.all.names)}"  
  
  vpc_id                     = aws_vpc.this[0].id
 
  cidr_block                 = var.public_subnets[count.index]

  availability_zone          = "${element(data.aws_availability_zones.all.names, count.index)}"

  map_public_ip_on_launch    = true

  # tags = "${merge(var.demo_env_default_tags, map(
  #   "Name", "${var.public_tg}",
  #   "Environment", "${var.vpc_tg}",
  #   "Client", "JCS"
  #   ))}"

}

#################
# Private subnet
#################

resource "aws_subnet" "private" {


  count                      = "${length(data.aws_availability_zones.all.names)}"  
  
  vpc_id                     = aws_vpc.this[0].id
 
  cidr_block                 = var.private_subnets[count.index]
  
  availability_zone          = "${element(data.aws_availability_zones.all.names, count.index)}"

  map_public_ip_on_launch    = false

  # tags = "${merge(var.demo_env_default_tags, map(
  #   "Name", "${var.private_tg}",
  #   "Environment", "${var.vpc_tg}",
  #   "Client", "JCS"
  #   ))}"

}

########################
# Public Network ACLs
########################

resource "aws_network_acl" "acls_pub_prod" {
  
  vpc_id                     = aws_vpc.this[0].id
  
  subnet_ids                 = aws_subnet.public.*.id 

/* This needs to be changeed to a resource type to allow for 
    future ports to be added and tested in different 
    environment!...*/
  ingress {    /* Rule # 100*/
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }  

  egress {     /* Rule 100 */
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
  {

    Name            = "${var.public_acl_tags} ${var.environment_tag}"
    Environment     = var.environment_tag
  },
  var.tags,    # Will be applied to all resources
  )
}

#######################
# Private Network ACLs
#######################

resource "aws_network_acl" "acls_private_prod" {
  
  vpc_id                     = aws_vpc.this[0].id
  
  subnet_ids                 = aws_subnet.private.*.id 

/* This needs to be changed to a resource type to allow for 
    future ports to be added and tested in different 
    environment!...*/
  ingress {    /* Rule # 100*/
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }  

  egress {     /* Rule 100 */
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # tags = "${merge(var.demo_env_default_tags, map(
  #   "Name", "${var.acls_private_prod_tg} - ${var.vpc_tg}",
  #   "Environment", "${var.vpc_tg}",
  #   "Client", "JCS"
  #   ))}"
}

##########################
# Route table association
##########################

resource "aws_route_table_association" "private" {
  
  count                      = "${length(data.aws_availability_zones.all.names)}"

  subnet_id                  = "${element(aws_subnet.private.*.id, count.index)}"
  
  route_table_id             = "${aws_route_table.private_rtb.id}"

}

resource "aws_route_table_association" "public" {
  
  count                      = "${length(data.aws_availability_zones.all.names)}"

  subnet_id                  = "${element(aws_subnet.public.*.id, count.index)}"
  
  route_table_id             = "${aws_route_table.public_rtb.id}"

}

###########
# Defaults
###########

resource "aws_default_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  enable_dns_support         = var.enable_dns_support
  enable_dns_hostnames       = var.enable_dns_hostnames
  enable_classiclink         = var.default_vpc_enable_classiclink

  # tags = "${merge(var.demo_env_default_tags, map(
  #   "Name", "${var.vpc_tg}",
  #   "Client", "JCS"
  #   ))}"
}