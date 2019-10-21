# Example

Configuration in this directory creates a Simple VPC with a minimum set of arguments.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

## Outputs

| Name | Description |
|------|-------------|
|vpc_name|Name of the VPC provisioned|
|region| The Region of the VPC|
|vpc_id | The ID of the VPC |
|vpc_cidr_block | The CIDR block of the VPC |
| private_subnets| List of IDs of private subnets |
| private_subnets_cidr_blocks | List of cidr_blocks of private subnets |
| public_subnets | List of IDs of public subnets |
| public_subnets_cidr_blocks | List of cidr_blocks of public subnets |