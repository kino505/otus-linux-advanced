variable "subnets" {
  description   = "Subnets"
}

variable "vpc_name" {
  type          = string
  description   = "VPC name"
}

variable "labels" {
  type          = map
  description   = "Labels"
  default       = {}
}

locals {
  subnets_private = var.subnets.private
  subnets_public  = var.subnets.public
}