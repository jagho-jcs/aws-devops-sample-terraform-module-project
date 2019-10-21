output "vpc_id" {
  value = aws_vpc.this[0].id
}

output "vpc_name" {
  value = var.name
}

output "vpc_cidr_block" {
  value = aws_vpc.this.*.cidr_block
}

output "public_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.public.*.id
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.public.*.cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.private.*.cidr_block
}