variable "name_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "inspection_vpc_cidr" {
  description = "CIDR block for the inspection VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}
