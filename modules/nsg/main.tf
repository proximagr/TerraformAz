//create a network security group with terraform
resource "azurerm_network_security_group" "nsg" {
  name                = "terraform-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

//create a network security group rule with terraform
resource "azurerm_network_security_rule" "nsg_rule" {
  name                        = "allowrdp"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

//output netowrk security group id
output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}