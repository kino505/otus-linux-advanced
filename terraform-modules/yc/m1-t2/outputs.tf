output "vpc_name" {
    value = module.network.vpc_name
}

output "folder_id" {
    value = module.network.folder_id
}

output "default_security_group_id" {
    value = module.network.default_security_group_id
}

output "public_subnets" {
    value = module.network.public_subnets
}

output "private_subnets" {
    value = module.network.private_subnets
}

output "subnets_by_zone" {
    value = module.network.subnets_by_zone
}

# output "private_subnets_by_zone" {
#     value = module.network.private_subnets_by_zone
# }

output "instances" {
  description = "The internal IP address of the instance"
  value       = {for k,v in module.instance: k => v}
}
