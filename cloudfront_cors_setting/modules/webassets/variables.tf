variable "project" {
  type        = string
  description = "Project name"
}

variable "allowed_origins" {
  type        = list(string)
  description = "list of allowd origin string"
}

variable "tags" {
  type = map(any)
}
