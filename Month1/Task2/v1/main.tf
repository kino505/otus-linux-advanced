module "network" {
  source   = "git@github.com:kino505/otus-linux-advanced.git//terraform-modules/yc/network?ref=master"
  subnets  = var.subnets
  vpc_name = var.vpc_name
}

module "instance" {
  source          = "git@github.com:kino505/otus-linux-advanced.git//terraform-modules/yc/compute_instance?ref=master"
  for_each        = toset(keys(var.instances))
  instance        = jsonencode(var.instances[each.key])
  subnet_id       = [for k,v in module.network.public_subnets: v.id if v.zone == var.instances[each.key].zone ][0]
  secondary_disks = try(var.instances[each.key].secondary_disks,{})
}


resource "null_resource" "ConfigureAnsibleLabelVariable" {
  depends_on = [ module.instance ]

  triggers   = {
    id = timestamp()
  }

  for_each = toset(keys(var.instances))
  
  provisioner "local-exec" {
    when       = create
    on_failure = continue
    command    = <<EOF
    cd ansible
    echo "[web]" > hosts
    echo ${module.instance[each.key].external_ip[0]} ansible_ssh_user=${module.instance[each.key].user[0]} ansible_ssh_private_key_file=${module.instance[each.key].private_key_file[0]} >> hosts
    ansible web -m ping -i hosts
    ansible-playbook nginx.yml -i hosts
EOF
  }
}
