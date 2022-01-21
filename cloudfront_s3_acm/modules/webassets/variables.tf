variable "bucket_list" {
  type        = list(map(string))
  description = "mapの要素 bucket_name,acl"
}

variable "tags" {
  type = map(any)
}