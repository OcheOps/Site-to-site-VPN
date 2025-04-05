
output "azure_public_ip" {
  value = azurerm_public_ip.vpn_ip.ip_address
}

output "aws_vpn_gateway_id" {
  value = aws_vpn_gateway.vpn_gw.id
}

output "vpn_connection_id" {
  value = aws_vpn_connection.vpn_conn.id
}
