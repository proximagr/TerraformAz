//create a resource group with terraform
resource "azurerm_resource_group" "rg" {
  name     = "Terraform-lab"
  location = "northeurope"
}

variable "counter" {
  type = number
  default = 2
}

//refer to the networking module
module "networking" {
  source = "./modules/networking"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

//create a network interface with terraform
resource "azurerm_network_interface" "nic" {
  //create multiple network interfaces using count
  count               = var.counter
  name                = "labvm01-nic-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "labvm01-ipconfig-${count.index}"
    subnet_id                     = module.networking.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

//create a windows virtual machine with terraform
resource "azurerm_windows_virtual_machine" "labvm01" {
  //create multiple virtual machines using count
  count                 = var.counter
  name                  = "labvm01-${count.index}"
    resource_group_name   = azurerm_resource_group.rg.name
    location              = azurerm_resource_group.rg.location
    size                  = "Standard_B1s"
    admin_username        = "labadmin"
    admin_password        = "Password1234!"
    network_interface_ids = [azurerm_network_interface.nic[count.index].id]
    
    os_disk {
        name              = "labvm01--${count.index}"
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    
    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-Datacenter"
        version   = "latest"
    }
}