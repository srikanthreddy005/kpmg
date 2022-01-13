# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "tier3" {
  count = 2
  name                = "tier3-${count.index}"
  computer_name       = "tier3-linux-${count.index}" # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [ element(azurerm_network_interface.tier3vmnic[*].id, count.index)]  
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "tier3-osdisk${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
}


