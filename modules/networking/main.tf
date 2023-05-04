//create a virtual network with terraform
resource "azurerm_virtual_network" "vnet" {
  name                = "terraform-vnet"
  address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = var.resource_group_name
}

//create a subnet with terraform
resource "azurerm_subnet" "subnet" {
  name                 = "terraform-subnet"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.0.0/24"]
}

//declare the nsg module
module "nsg" {
  source              = "../nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

//associate the subnet with the network secuirty group in the nsg module
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = module.nsg.nsg_id
}

# Path: modules\networking\main.tf
//provide output for the subnet id
output "subnet_id" {
  value = azurerm_subnet.subnet.id
}