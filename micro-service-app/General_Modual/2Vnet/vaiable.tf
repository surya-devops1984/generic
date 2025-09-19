variable "vnet_name" {
    type = string
    default = "vnet"
}

variable "rg-name" {
    type = string
}

variable "vnet_address" {
    type = list(string)
}