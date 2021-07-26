# #########################################################
# Azure VM Creation- Initial draft prepared by - Aniket Mukherjee
# This will create resource group, vnet, subnet and virtual machine.
# #########################################################

data "azurerm_resource_group" "vmresourcegroup" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vmvnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

data "azurerm_subnet" "vnet_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group_name
}


# Create public IPs
resource "azurerm_public_ip" "vmpublicip" {
    count                        = var.vm_count 
    name                         = "myPublicIP-${format("%02d",count.index)}"
    location                     = data.azurerm_resource_group.vmresourcegroup.location
    resource_group_name          = data.azurerm_resource_group.vmresourcegroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = var.environment
        business    = var.business_unit_group
        description = var.description
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
    name                = "myNetworkSecurityGroup"
    location            = data.azurerm_resource_group.vmresourcegroup.location
    resource_group_name = data.azurerm_resource_group.vmresourcegroup.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = var.environment
        business    = var.business_unit_group
        description = var.description
    }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
    count                     = var.vm_count 
    name                      = "myNIC-${format("%02d",count.index)}"
    location                  = data.azurerm_resource_group.vmresourcegroup.location
    resource_group_name       = data.azurerm_resource_group.vmresourcegroup.name

    ip_configuration {
        name                          = "myNicConfiguration-${format("%02d",count.index)}"
        subnet_id                     = data.azurerm_subnet.vnet_subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = element(azurerm_public_ip.vmpublicip.*.id,count.index)
    }

    tags = {
        environment = var.environment
        business    = var.business_unit_group
        description = var.description
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsgnicassociation" {
    count                     = var.vm_count
    network_interface_id      = element(azurerm_network_interface.nic.*.id,count.index)
    network_security_group_id = azurerm_network_security_group.nsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = data.azurerm_resource_group.vmresourcegroup.name
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = data.azurerm_resource_group.vmresourcegroup.name
    location                    = data.azurerm_resource_group.vmresourcegroup.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = var.environment
        business    = var.business_unit_group
        description = var.description
    }
}

# Create (and display) an SSH key
resource "tls_private_key" "vmssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
    count                     = var.vm_count 
    name                      = "myVM-${format("%02d",count.index)}"
    location              = data.azurerm_resource_group.vmresourcegroup.location
    resource_group_name   = data.azurerm_resource_group.vmresourcegroup.name
    network_interface_ids = [element(azurerm_network_interface.nic.*.id,count.index)]
    size                  = var.vm_size

    os_disk {
        name              = "myOsDisk-${format("%02d",count.index)}"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "myvm-${format("%02d",count.index)}"
    admin_username = var.admin_ssh_user_name
    disable_password_authentication = true

    admin_ssh_key {
        username       = var.admin_ssh_user_name
        public_key     = tls_private_key.vmssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = var.environment
        business    = var.business_unit_group
        description = var.description
    }
}


