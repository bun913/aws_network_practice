variable "vpc_cidr" {
  type        = string
  description = "VPCiderBlocks"
}

variable "project" {
  type        = string
  description = "Project Nmae"
}

variable "tags" {
  type        = map(any)
  description = "DeafaultTags for this project"
}

variable "db_subnets" {
  type        = list(map(string))
  description = "DB Subnet Settings"
}

variable "bastion_subnets" {
  type        = list(map(string))
  description = "Bastion Subnet Settings"
}
