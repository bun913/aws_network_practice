variable "alb_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "alb_subnets" {
  type = list(string)
}
variable "tags" {
  type        = map(any)
  description = "DeafaultTags for this project"
}
