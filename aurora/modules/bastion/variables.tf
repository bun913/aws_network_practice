variable "project" {
  type = string
}
variable "inbound_sg_name" {
  type = string
}

variable "outbound_sg_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "route_table_id" {
  type = string
}

variable "interface_services" {
  type        = list(string)
  description = "VPC Endpoint service names(Type: Interface)"
}

variable "gateway_services" {
  type        = list(string)
  description = "VPC Endpoint service names(Type: Gateway)"
}

variable "bastion_subnet" {
  type        = string
  description = "EC2 subnet id"
}

variable "db_subnet_cidrs" {
  type        = list(string)
  description = "Subnet CidrBlocks for DB"
}

variable "tags" {
  type = map(string)
}
