resource "yandex_vpc_network" "this" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  for_each       = local.subnets_public
  name           = "public-${each.key}-${each.value.name}"
  v4_cidr_blocks = each.value.v4_cidr
  zone           = try(each.value.zone,"ru-central1-a")
  network_id     = yandex_vpc_network.this.id
  labels         = merge(var.labels, {
    "Name" = "public-${each.key}-${each.value.name}"
  })
}

resource "yandex_vpc_subnet" "private" {
  for_each       = local.subnets_private
  name           = "private-${each.key}-${each.value.name}"
  v4_cidr_blocks = each.value.v4_cidr
  zone           = try(each.value.zone,"ru-central1-a")
  network_id     = yandex_vpc_network.this.id
  labels         = merge(var.labels, {
    "Name" = "private-${each.key}-${each.value.name}"
  })
}