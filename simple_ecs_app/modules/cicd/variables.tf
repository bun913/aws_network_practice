variable "project" {
  type = string
}
variable "region" {
  type = string
}
variable "ecr_repo" {
  type        = string
  description = "ECR repository uri"
}
variable "cluster_name" {
  type = string
}
variable "service_name" {
  type = string
}
variable "blue_listner_arn" {
  type = string
}
variable "green_listner_arn" {
  type = string
}
variable "blue_targetgroup_name" {
  type = string
}
variable "green_targetgroup_name" {
  type = string
}
