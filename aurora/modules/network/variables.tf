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

variable "subnets" {
  type        = list(map(string))
  description = "Subnet Settings"
}
