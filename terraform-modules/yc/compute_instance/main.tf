data "yandex_compute_image" "this" {
  family = local.instance.image_family
}

resource "yandex_compute_disk" "secondary_disks" {
  for_each    = var.secondary_disks
  name        = each.key
  size        = each.value.size
  zone        = local.instance.zone
  
  lifecycle {
    create_before_destroy = false
  }
}

resource "yandex_compute_instance" "this" {
  name               = local.instance.name
  platform_id        = local.instance.platform_id
  zone               = local.instance.zone
  description        = local.instance.description
  hostname           = try(local.instance.hostname,local.instance.name)
  folder_id          = local.instance.folder_id
  service_account_id = local.instance.service_account_id
  labels             = merge(local.common_labels,local.instance.labels)

  resources {
    cores         = local.instance.cores
    memory        = local.instance.memory
    core_fraction = local.instance.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.this.id
      type     = local.instance.boot_disk_type
      size     = local.instance.boot_disk_size
    }
  }

  lifecycle {
    ignore_changes = [boot_disk]
  }

  dynamic "secondary_disk" {
    for_each = var.secondary_disks
    content {
      auto_delete = lookup(secondary_disk.value, "auto_delete", true)
      disk_id     = yandex_compute_disk.secondary_disks[secondary_disk.key].id
    }
  }

  network_interface {
    subnet_id      = var.subnet_id
    nat            = local.instance.is_nat
    nat_ip_address = local.instance.nat_ip_address
    ip_address     = local.instance.ip_address
  }

  scheduling_policy {
    preemptible = local.instance.preemptible
  }

  metadata = {
    user-data          = local.instance.user-data
    ssh-keys           = "${local.instance.user}:${file("${local.instance.ssh_pubkey}")}"
    serial-port-enable = local.instance.serial-port-enable
  }

  allow_stopping_for_update = local.instance.allow_stopping_for_update

  provisioner "remote-exec" {
    connection {
      type        = local.instance.type_remote_exec
      user        = local.instance.user
      host        = self.network_interface["0"].nat_ip_address
      private_key = file("${local.instance.private_key}")
      password    = local.instance.password
      https       = local.instance.https
      port        = local.instance.port
      insecure    = length(local.instance.insecure) > 0 ? local.instance.insecure : null
      timeout     = local.instance.timeout
    }
    inline = [
      "echo Check connection...."
    ]
  }

  # provisioner "local-exec" {
  #   command = "ansible-playbook -u username -i '${self.public_ip},' --private-key ${var.ssh_key_private} provision.yml" 
  # }
}
