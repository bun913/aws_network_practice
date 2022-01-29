variable "project" {
  type    = string
  default = "cors-sample"
}
variable "region" {
  type    = string
  default = "ap-northeast-1"
}
variable "tags" {
  default = {
    "Terraform" = "True",
    "Project"   = "cors-sample"
  }
  type = map(string)
}
