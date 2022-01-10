variable "security_group_name" {
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

variable "tags" {
  type = map(string)
}
