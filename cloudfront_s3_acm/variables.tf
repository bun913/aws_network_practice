variable "tags" {
  type = map(string)
  default = {
    "Name" = "acm-cloudfront-practice"
    "Terraform" = "True"
  }
}
