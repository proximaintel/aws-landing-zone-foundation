variable "root_ou_id" {
  description = "Root OU ID for organization-wide SCPs"
  type        = string
}

variable "workloads_ou_id" {
  description = "Workloads OU ID for workload-specific SCPs"
  type        = string
}
