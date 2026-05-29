variable "org_name" {
  description = "Organization name used for tagging"
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}
