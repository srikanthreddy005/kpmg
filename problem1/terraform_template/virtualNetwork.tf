# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  address_space       = var.virtual_network_address_space
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

# Create Subnet
resource "azurerm_subnet" "mysubnet1" {
#  name                 = "mysubnet-1"
  name                 = "${azurerm_virtual_network.myvnet.name}-${var.subnet1}"                  
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = [var.subnets_address_space[0]]
}

resource "azurerm_subnet" "mysubnet2" {
  name                 = "${azurerm_virtual_network.myvnet.name}-${var.subnet2}"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = [var.subnets_address_space[1]]
}

resource "azurerm_subnet" "mysubnet3" {
  name                 = "${azurerm_virtual_network.myvnet.name}-${var.subnet3}"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = [var.subnets_address_space[2]]
}
resource "azurerm_network_security_group" "mysubnet1nsg" {
  name                =  "${azurerm_subnet.mysubnet1.name}-nsg"
  resource_group_name  = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location

  security_rule {
    name                       = "http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "ssh"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "ssh"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.3.0/24"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "mysubnet1" {
  subnet_id                 = azurerm_subnet.mysubnet1.id
  network_security_group_id = azurerm_network_security_group.mysubnet1nsg.id
}


resource "azurerm_network_security_group" "mysubnet2nsg" {
  name                = "mysubnet2-nsg"
  resource_group_name  = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }
    #allow ssh only from subnet 1
    security_rule {
    name                       = "ssh"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"   
    }

}

resource "azurerm_subnet_network_security_group_association" "mysubnet2" {
  subnet_id                 = azurerm_subnet.mysubnet2.id
  network_security_group_id = azurerm_network_security_group.mysubnet2nsg.id
}


resource "azurerm_network_security_group" "mysubnet3nsg" {
  name                = "mysubnet3-nsg"
  resource_group_name  = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location


  security_rule {
    name                       = "rule1"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "ssh"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3306"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "*"   
  }

    security_rule {
    name                       = "ssh"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "*"   
  }

}

resource "azurerm_subnet_network_security_group_association" "mysubnet3" {
  subnet_id                 = azurerm_subnet.mysubnet3.id
  network_security_group_id = azurerm_network_security_group.mysubnet3nsg.id
}

# Create Azure Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  count = 2
  name                = "mypublicip-${count.index}"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-vm-${count.index}-${random_string.myrandom.id}"  
}

# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  count =2 
  name                = "vmnic-${count.index}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet1.id
    private_ip_address_allocation = "Static"
    public_ip_address_id = element(azurerm_public_ip.mypublicip[*].id, count.index)     
  }
}
resource "azurerm_network_interface" "tier2vmnic" {
  count =2 
  name                = "tier2vmnic-${count.index}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet2.id
    private_ip_address_allocation = "Static"

  }
}

resource "azurerm_network_interface" "tier3vmnic" {
  count =2 
  name                = "tier3vmnic-${count.index}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet3.id
    private_ip_address_allocation = "Static"

  }
}

