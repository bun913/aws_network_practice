variable "project" {
  type = string
}
variable "subnet_group_name" {
  type = string
}

variable "sg_group_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "allow_sg_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "tags" {
  type        = map(string)
  description = "ProjectDefaultTags"
}

variable "cluster_settings" {
  type = object({
    cluster_name            = string
    engine                  = string
    engine_version          = string
    availability_zones      = list(string)
    database_name           = string
    master_username         = string
    master_password         = string
    backup_retention_period = number
  })
  description = "cluster settings map"
}

variable "instance_class" {
  type    = string
  default = "db.t3.small"
}
