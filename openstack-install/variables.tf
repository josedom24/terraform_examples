variable "secret_key" {}

variable "ext-net" { default = "ext-net"}

variable "ip_subred-ext" {default = "192.168.1.0/24"}
variable "dns_subred-ext" { type="list" default=["192.168.102.2"]}
variable "ip_subred-int" {default = "192.168.221.0/24"}

variable "imagen" {default = "ca6effe7-0a47-4257-8624-713225a0bbdd"}
variable "sabor" {default = "13"}
variable "key_ssh" {default = "key_jdmr"}