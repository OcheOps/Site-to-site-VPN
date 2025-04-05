
variable "resource_group_name" {
  description = "Azure Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_cidr" {
  description = "Azure VNet CIDR block"
  type        = string
}

variable "subnet_cidr" {
  description = "GatewaySubnet CIDR block"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_vpc_cidr" {
  description = "AWS VPC CIDR block"
  type        = string
}

variable "shared_key" {
  description = "Pre-shared key for VPN"
  type        = string
  sensitive   = true
}
