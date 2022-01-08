variable "tags" {
  type = map(string)
  default = {
    "Name"      = "acm-cloudfront-practice"
    "Terraform" = "True"
  }
}

variable "root_domain" {
  type = string
}
