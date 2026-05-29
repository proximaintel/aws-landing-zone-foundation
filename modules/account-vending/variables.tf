variable "name_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID for spoke attachment"
  type        = string
}

variable "spoke_vpc_cidr" {
  description = "CIDR block for the baseline spoke VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "budget_limit" {
  description = "Monthly budget limit in USD for new accounts"
  type        = number
  default     = 1000
}

variable "required_tags" {
  description = "Tags required on all resources in vended accounts"
  type        = map(string)
  default = {
    managed_by  = "terraform"
    environment = "production"
  }
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}
