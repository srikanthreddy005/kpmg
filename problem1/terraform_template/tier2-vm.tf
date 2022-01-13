# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "tier2" {
  count = 2
  name                = "tier2-${count.index}"
  computer_name       = "tier2-linux-${count.index}" # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [ element(azurerm_network_interface.tier2vmnic[*].id, count.index)]  
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "tier2-osdisk${count.index}"
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


