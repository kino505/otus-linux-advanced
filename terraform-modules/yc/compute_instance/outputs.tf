output "internal_ip" {
  description = "The internal IP address of the instance"
  value       = yandex_compute_instance.this.*.network_interface.0.ip_address
}

output "external_ip" {
  description = "The external IP address of the instance"
  value       = yandex_compute_instance.this.*.network_interface.0.nat_ip_address
}

output "fqdn" {
  description = "The fully qualified DNS name of this instance"
  value       = yandex_compute_instance.this.*.fqdn
}

output "user" {
  description = "The ssh username"
  value       = local.instance.*.user
}

output "private_key_file" {
  description = "The ssh private keyfilename"
  value       = local.instance.*.private_key
}