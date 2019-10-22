data "aws_availability_zones" "all" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

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

    "Name:" = "${var.igw_tag}_${var.name}"
  },
  var.tags,    # Will be applied to all resources
  )
}

################
# Publiс routes
################

resource "aws_route_table" "public_rtb" {
  
  vpc_id                     = aws_vpc.this[0].id

  tags = merge(
  {

    Name            = "${var.environment_tag} - ${var.public_route_table_tag}"
    Environment     = var.environment_tag
  },
  var.tags,    # Will be applied to all resources
  )
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


  lifecycle {

    # When attaching VPN gateways it is common to define aws_vpn_gateway_route_propagation
    # resources that manipulate the attributes of the routing table (typically for the private subnets)

            ignore_changes   = [propagating_vgws]
  }
  tags = merge(
  {

    Name            = "${var.environment_tag} - ${var.private_route_table_tag}"
    Environment     = var.environment_tag

  },
  var.tags,    # Will be applied to all resources
  )
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

  tags = merge(
  {

    Name            = var.public_subnet_tag
    Environment     = var.environment_tag
  },
  var.tags,    # Will be applied to all resources
  )

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

  tags = merge(
  {

    Name            = var.private_subnet_tag
    Environment     = var.environment_tag
  },
  var.tags,    # Will be applied to all resources
  )

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

    Name            = "${var.public_acl_tag} ${var.environment_tag}"
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

  tags = merge(
  {

    Name            = "${var.private_acl_tag} ${var.environment_tag}"
    Environment     = var.environment_tag
  },
  var.tags,    # Will be applied to all resources
  )
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

  tags = merge(
  {

    Name = "do not use!.."

  },
    var.tags,    # Will be applied to all resources
    var.default_vpc_tags,
    )
}


resource "aws_security_group" "web-instance-sg" {
  name              = "web-instance-sg"
  description       = "Allows Access for the nginx app"
  vpc_id            = "${aws_vpc.this[0].id}"

  ingress {
    description     = "Allows unsecure traffic to the nginx"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allows secure traffic from the nginx app"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allows traffic to the nginx"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allows ssh access to the web instance"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["188.28.164.94/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
    
  tags = merge(
  {

    Name      = "web-instance-sg"
    VPC       = var.name

  },
    var.tags,    # Will be applied to all resources
    var.security_groups_tags,
    )
}

resource "aws_security_group" "alb_hsbc_sg" {
  
  name                              = "hsbc_nginx_sg_alb"
  description                       = "hsbc-aws DevOps Project"
  vpc_id                            = "${aws_vpc.this[0].id}"

  ingress {
    description     = "Allows http traffic to the Application Load Balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allows http traffic to the Application Load Balancer"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = merge(
  {

    Name      = "hsbc_nginx_sg_alb"
    VPC       = var.name

  },
    var.tags,    # Will be applied to all resources
    var.security_groups_tags,
    )
}

resource "aws_key_pair" "auth-key" {

  key_name                = "${var.key_name}"
  public_key              = "${file(var.public_key_path)}"
  
}

resource "aws_instance" "web-instance" {

  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  
  connection {
  
    # The default username for our AMI
  
    type                  = "ssh"
    user                  = "ubuntu"
    host                  = "${self.public_ip}"
    private_key           = file(var.private_key_path)
  
    # The connection will use the local SSH agent for authentication.
  
  }
  
  count                   = "${length(data.aws_availability_zones.all.names)}"

  instance_type           = "${var.instance_type}"

  user_data = <<-EOF
                #!/bin/bash
                hostname="hsbc-demo-sprgbtsvr"
                hostnamectl set-hostname $hostname
                sudo sed -i " 1 s/.*/& $hostname/" /etc/hosts
                EOF

  ami                     = "${data.aws_ami.ubuntu.id}"

  key_name                = "${aws_key_pair.auth-key.id}"
  
  vpc_security_group_ids  = [ aws_security_group.web-instance-sg.id ]

  subnet_id               = "${element(aws_subnet.public.*.id, count.index)}"

  provisioner "file" {
    source      = "./java-spring-boot-app/demo-0.0.1-SNAPSHOT.jar"
    destination = "/tmp/demo-0.0.1-SNAPSHOT.jar"
  } 

  provisioner "file" {
    source      = "./java-spring-boot-app/scripts/helloworld.service"
    destination = "/tmp/helloworld.service"
  }

  provisioner "file" {
    source      = "./java-spring-boot-app/scripts/helloworld.service"
    destination = "/tmp/helloworld.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y upgrade",
      "sudo apt-get update",
      "sudo unattended-upgrade",
      "sudo apt-get update",
      "sudo apt-get install -y openjdk-8-jdk",      
      "sudo apt-get update",
      "sudo apt-get -y install nginx",
      "sudo systemctl start nginx",
      "sudo apt-get -y upgrade",
      "sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak",
      "sudo mv /tmp/helloworld.conf /etc/nginx/sites-available/helloworld.conf",
      "sudo apt-get autoremove -y",
      "sudo mkdir /opt/helloworld",
      "sudo mv /tmp/helloworld.service /etc/systemd/system/",
      "sudo mv /tmp/demo-0.0.1-SNAPSHOT.jar /opt/helloworld",
      "sudo systemctl start helloworld.service",
      "sudo ufw allow ssh",
      "sudo ufw allow 8080",
      "sudo ufw --force enable"
    ]
  }

  tags = merge(
  {

    Name = var.web_cluster_tag

  },
    var.tags,    # Will be applied to all resources
    var.demo_env_default_tags,
    )
}

resource "aws_launch_configuration" "as_conf_web_instance" {
  
  name_prefix                       = "nginx-lc-"
  image_id                          = "${data.aws_ami.ubuntu.id}"
  instance_type                     = "${var.instance_type}"
    
  lifecycle {

    create_before_destroy           = true
  }
  
}

resource "aws_autoscaling_group" "wb_instance_asg" {

  name                              = "Nginx Web Instance ASG"
  
  launch_configuration              = "${aws_launch_configuration.as_conf_web_instance.name}"
  
  vpc_zone_identifier               = flatten(["${aws_subnet.public.*.id}"])

  desired_capacity                  = var.desired_capacity
  min_size                          = var.min_size
  max_size                          = var.max_size

  lifecycle {

    create_before_destroy           = true
  }
}

resource "aws_alb" "hsbc_alb" {

  name               = "HSBC-Nginx-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.alb_hsbc_sg.id, aws_security_group.web-instance-sg.id ]
  
  subnets            = aws_subnet.public.*.id
  
  tags = {
    Environment = "hsbc-demo-alb"
  }
}

resource "aws_alb_target_group_attachment" "hsbc_nginx_grp_att" {

  count             = length(aws_subnet.public.*.id)
  target_group_arn  = aws_alb_target_group.hsbc_nginx_tgrp.arn
  target_id         = element(aws_instance.web-instance.*.id, count.index)
  port              = var.aws_alb_tgt_grp_att_port

}

resource "aws_alb_target_group" "hsbc_nginx_tgrp" {
  
  name              = "HSBC-NginxTargetGroup"
  port              = var.aws_alb_target_group_port
  protocol          = "HTTP"
  vpc_id            = "${aws_vpc.this[0].id}"
}

resource "aws_autoscaling_attachment" "asg_att_hsbc_nginx" {
  
  autoscaling_group_name = "${aws_autoscaling_group.wb_instance_asg.id}"
  alb_target_group_arn   = "${aws_alb_target_group.hsbc_nginx_tgrp.arn}"
}

resource "aws_alb_listener" "front_end" {
  
  load_balancer_arn = "${aws_alb.hsbc_alb.arn}"
  port              = var.aws_alb_listener_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.hsbc_nginx_tgrp.arn}"
    type = "forward"
  }
}