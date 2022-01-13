# Input Variables

# 1. Business Unit Name
variable "business_unit" {
  description = "Business Unit Name"
  type = string 
  default = "kpmg"
}
# 2. Environment Name
variable "environment" {
  description = "Environment Name"
  type = string
  default = "dev"
}
# 3. Resource Group Name
variable "resource_group_name" {
  description = "Resource Group Name"
  type = string
  default = "myrg"
}
# 4. Resource Group Location
variable "resource_group_location" {
  description = "Resource Group Location"
  type = string
  default = "East US"
}
# 5. Virtual Network Name
variable "virtual_network_name" {
  description = "Virtual Network Name"
  type = string
  default = "vnet"
}

variable "subnet1"{
    description = "subnet suffix"
    type = string
    default = "subnet1"
}
variable "subnet2"{
    description = "subnet suffix"
    type = string
    default = "subnet2"
}
variable "subnet3"{
    description = "subnet suffix"
    type = string
    default = "subnet3"
}

variable "virtual_network_address_space" {
    description = "CIDR blocks"
    type = list(string)
    default = [ "10.0.0.0/16" ]
  
}
variable "subnets_address_space" {
    description = "CIDR blocks"
    type = list(string)
    default = [ "10.0.1.0/24","10.0.2.0/24","10.0.3.0/24" ]
  
}

variable "primary_database" {
    description = "db name"
    type = string
    default = "kpmgdb01"
}

variable "primary_database_version" {
    description = "db serverversion"
    type = string
    default = "12.0"
  }

variable "primary_database_admin" {
    description = "db admin"
    type = string
  }
variable "primary_database_password" {
    description = "db pwd"
    type = string
  }