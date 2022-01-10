variable "project" {
  type    = string
  default = "aurora-practice"
}
variable "tags" {
  default = {
    "Terraform" = "True",
    "Project"   = "aurora-practice"
  }
  type = map(string)
}

variable "vpc" {
  type        = map(string)
  description = "VPCSettings from tfvars"
}

variable "db_subnets" {
  type        = list(map(string))
  description = "SubnetsSettings from tfvars"
}

variable "bastion_subnets" {
  type        = list(map(string))
  description = "SubnetsSettings from tfvars"
}

variable "vpc_endpoint" {
  type        = map(any)
  description = "vpc_endpoint_setting"
}
