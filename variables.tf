variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "vpc_id" {
  description = "(Optional, Forces new resource) VPC ID. Defaults to the region's default VPC."
}

variable "inbound_ports" {
  description = "Inbound ports"
  type = map(object({
    port = number
  }))
  default = {
    "http" = {
      port = 80
    },
    "https" = {
      port = 443
    }
  }

}

variable "ingress_cidr_ipv4" {
  type = list(string)
}

variable "allow_internal_traffic" {
  description = "Whether to allow all internal traffic"
  type        = bool
  default     = false
}

variable "internal_cidr_blocks" {
  description = "List of internal CIDR blocks to allow (if enabled)"
  type        = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
