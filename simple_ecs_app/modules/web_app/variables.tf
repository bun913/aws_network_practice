variable "project" {
  type = string
}
variable "alb_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "alb_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "tags" {
  type        = map(any)
  description = "DeafaultTags for this project"
}

variable "interface_services" {
  type        = list(string)
  description = "Service_names for interface vpc endpoint"
}

variable "gateway_services" {
  type        = list(string)
  description = "Service_names for gateway vpc endpoint"
}

variable "private_route_table_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "container_image_url" {
  type = string
}

variable "region" {
  type = string
}
