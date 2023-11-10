variable "yc_token" {
  type        = string
  description = "Yandex Cloud API key"
  default = null
}

variable "yc_cloud_id" {
  type        = string
  description = "Yandex Cloud id"
  default = null
}

variable "yc_folder_id" {
  type        = string
  description = "Yandex Cloud folder id"
  default = null
}

variable "yc_zone" {
  type        = string
  description = "Yandex Cloud compute default zone"
  default     = "ru-central1-a"
}

variable "vpc_name" {
  type          = string
  description   = "VPC name"
}

variable "environment" {
  type          = string
  description   = "Env name"
}

variable "subnets" {
  description   = "Subnets"
}

variable "instances" {
  description = "Instances"
}

locals {
  subnets_private = var.subnets.private
  subnets_public  = var.subnets.public
  ## labels have to begin with small letter!!! If label key will begin from Upper letter is will be error!!
  common_labels = {
    environment = var.environment
    terraform   = "true"
  }
}