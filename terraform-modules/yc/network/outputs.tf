output "vpc_name" {
    value = yandex_vpc_network.this.name
}

output "folder_id" {
    value = yandex_vpc_network.this.folder_id
}

output "default_security_group_id" {
    value = yandex_vpc_network.this.default_security_group_id
}

output "public_subnets" {
    value = { for k,v in yandex_vpc_subnet.public: k => { 
        "id": v.id,
        "name": v.name,
        "v4_cidr_block": v.v4_cidr_blocks,
        "zone": v.zone
    }
    }
}

output "private_subnets" {
    value = { for k,v in yandex_vpc_subnet.private: k => {
        "id": v.id,
        "name": v.name,
        "v4_cidr_block": v.v4_cidr_blocks,
        "zone": v.zone
    }
    }
}
