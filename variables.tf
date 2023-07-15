variable "cidr_block" {
    type = string
    default = "10.0.0.0/16"
}
variable "instance_tenancy" {
    type = string
    default = "default"
  
}
variable "dns_support" {
    type = bool
    default = true
  
}
variable "dns_hostname" {
    type = bool
    default = true
  
}
variable "tags" {
    type = map(string)
    default = {
      Name = "Timing"
      Terraform = "true"
      Environment = "DEV"
      Clinet = "Flipkart"
    }
  
}
variable "postgress_port" {
    type = number
    default = 5482
}
variable "cidr_list" {
    type = list
    default = ["10.0.1.0/24", "10.0.2.0/24"]  
}
variable "tags1" {
    type = string
    default = "timing1"
}
variable "tagnat" {
    type = string
    default = "timing1-NAT"  
}
variable "public_cidrblock" {
    type = string
    default = "10.0.1.0/24"
  
}
variable "private_cidrblock" {
    type = string
    default = "10.0.11.0/24"
  
}
variable "database_cidrblock" {
    type = string
    default = "10.0.21.0/24"
  
}
variable "Allow_all" {
    type = string
    default = "0.0.0.0/0"
  
}

