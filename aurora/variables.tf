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

variable "subnets" {
  type        = list(map(string))
  description = "SubnetsSettings from tfvars"
}
