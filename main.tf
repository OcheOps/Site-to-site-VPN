
provider "azurerm" {
  features {}
}

provider "aws" {
  region = var.aws_region
}

# Azure Resources
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "azure-vnet"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_public_ip" "vpn_ip" {
  name                = "azure-vpn-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = "azure-vpn-gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"
  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_ip.id
    subnet_id                     = azurerm_subnet.gateway_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# AWS Resources
resource "aws_vpc" "vpc" {
  cidr_block = var.aws_vpc_cidr
  tags = {
    Name = "aws-vpc"
  }
}

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "aws-vpn-gw"
  }
}

resource "aws_customer_gateway" "azure_gw" {
  bgp_asn    = 65000
  ip_address = azurerm_public_ip.vpn_ip.ip_address
  type       = "ipsec.1"
  tags = {
    Name = "azure-customer-gw"
  }
}

resource "aws_vpn_connection" "vpn_conn" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gw.id
  customer_gateway_id = aws_customer_gateway.azure_gw.id
  type                = "ipsec.1"
  static_routes_only  = true
  tags = {
    Name = "aws-to-azure-vpn"
  }
}

# Azure Local Network Gateway & Connection
data "aws_vpn_connection" "vpn_conn_data" {
  id = aws_vpn_connection.vpn_conn.id
}

resource "azurerm_local_network_gateway" "aws_side" {
  name                = "aws-local-gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  gateway_address     = data.aws_vpn_connection.vpn_conn_data.tunnel1_address
  address_space       = [var.aws_vpc_cidr]
}

resource "azurerm_virtual_network_gateway_connection" "azure_to_aws" {
  name                            = "azure-to-aws-connection"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg.name
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vpn_gateway.id
  local_network_gateway_id        = azurerm_local_network_gateway.aws_side.id
  type                            = "IPsec"
  shared_key                      = var.shared_key
  connection_protocol             = "IKEv2"
}
