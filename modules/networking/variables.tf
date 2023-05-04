variable "location" {
    description = "The Azure Region in which all resources in this example should be created."
    type = string
    default = "North Europe"
}

variable "resource_group_name" {
    description = "The name of the resource group in which all resources in this example should be created."
    type = string
    default = "rg-terraform-azure"
}
