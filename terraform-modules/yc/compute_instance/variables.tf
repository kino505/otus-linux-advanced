variable "instance" {
  description = "Yandex Cloud Compute instances"
  type        = string
  default     = ""
}

variable "secondary_disks" {
  description = "Secondary disks"
  type        = map
  default     = {}
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

locals {
  common_labels = {
    modulename = "yc/compute_instance_v3",
    terraform  = true
  }

  instance_default = {
    "allow_stopping_for_update"   : false,
    "boot_disk_size"              : 10,
    "boot_disk_type"              : "network-hdd",
    "core_fraction"               : 20,
    "cores"                       : 2,
    "description"                 : "Default description",
    "folder_id"                   : "",
    "https"                       : null,
    "image_family"                : "debian-11",
    "insecure"                    : "",
    "ip_address"                  : "",
    "is_nat"                      : false,
    "labels"                      : {},
    "memory"                      : 1,
    "name"                        : "default-name",
    "nat_ip_address"              : "",
    "password"                    : "",
    "platform_id"                 : "standart-v3",
    "port"                        : 22,
    "preemptible"                 : true,
    "private_key"                 : "~/.ssh/id_rsa",
    "serial-port-enable"          : null,
    "service_account_id"          : "",
    "ssh_pubkey"                  : "~/.ssh/id_rsa.pub",
    "timeout"                     : "5",
    "type_remote_exec"            : "ssh",
    "user-data"                   : null,
    "user"                        : "debian"
    "zone"                        : "ru-central1-a",
  }

  instance = merge(local.instance_default,jsondecode(var.instance))
}