The nginx will be provisioned with terraform and ansible. \
It is version 1 for homework. The v1 is very simple according the homework requirements.\
For deploy Nginx you should prepare YC token, cloud_id and folder_id. Usualy, envrionment variables could be used. For example:
```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```
Often I create ~/.bash_alias:
```
yc-setprofile() {
  export YC_TOKEN=$(yc iam create-token)
  export YC_CLOUD_ID=$(yc config get cloud-id)
  export YC_FOLDER_ID=$(yc config get folder-id)
}
```
And I could execute this as  
#yc-setprofile  
And we should use a terraform/tofu:
```
#terraform init
#terraform plan
#terraform apply -auto-approve
```

The config file has JSON format and should be named as **vars.auto.tfvars.json**.\
Description:
```yc_zone - Have to pint to YC zone by default.\
environment - Environment name for Labels.\
vpc_name - Name for YC VPC. We'll creating a new VPC and subnets
subnets - Subnets block description:
  private - describe private subnets
  public  - describe public subnets
    "a": {
                "name": "1",
                "v4_cidr": ["10.10.0.0/24"],
                "zone": "ru-central1-a"
            }
instances - Instances describe block
        "instanceA": {
            "name"          : Instance name
            "platform_id"   : YC Platform ID of instance
            "zone"          : YC zone for this instance
            "cores"         : Cores
            "core_fraction" : Core fraction
            "preemptible"   : Preemptible ?
            "memory"        : Memory value
            "image_family"  : Image family
            "is_nat"        : Should the external IP be able to
            "boot_disk_size": Boot disk size
        }
```

Full example for one instance and one subnet, without any secondary disks:
```
{
    "yc_zone": "ru-central1-a",
    "environment": "edu",
    "vpc_name": "edu-vpc",
    "subnets": {
        "private": {},
        "public": {
            "a": {
                "name": "1",
                "v4_cidr": ["10.10.0.0/24"],
                "zone": "ru-central1-a"
            }
        }
    },
    "instances": {
        "nginx": {
            "name"          : "nginx",
            "platform_id"   : "standard-v2",
            "zone"          : "ru-central1-b",
            "cores"         : 2,
            "core_fraction" : 5,
            "preemptible"   : true,
            "memory"        : 1,
            "image_family"  : "debian-11",
            "is_nat"        : true,
            "boot_disk_size": 10
        }
    }
}
```
Full example for two instances and four subnets, with two secondary disks on thefirst instance named nginx:
```
{
    "yc_zone": "ru-central1-a",
    "environment": "edu",
    "vpc_name": "edu-vpc",
    "subnets": {
        "private": {
            "a": {
                "name": "1",
                "v4_cidr": ["10.1.0.0/24"],
                "zone": "ru-central1-a"
            },
            "b": {
                "name": "1",
                "v4_cidr": ["10.2.0.0/24"],
                "zone": "ru-central1-b"
            }
        },
        "public": {
            "a": {
                "name": "1",
                "v4_cidr": ["10.10.0.0/24"],
                "zone": "ru-central1-a"
            },
            "b": {
                "name": "1",
                "v4_cidr": ["10.11.0.0/24"],
                "zone": "ru-central1-b"
            }
        }
    },
    "instances": {
        "nginx": {
            "name"          : "nginx",
            "platform_id"   : "standard-v2",
            "zone"          : "ru-central1-a",
            "cores"         : 2,
            "core_fraction" : 5,
            "preemptible"   : true,
            "memory"        : 1,
            "image_family"  : "debian-11",
            "is_nat"        : true,
            "boot_disk_size": 10,
            "secondary_disks": {
                "data": {
                    "type": "network-hdd",
                    "size": 1,
                    "auto_delete": true
                },
                "var": {
                    "type": "network-hdd",
                    "size": 1,
                    "auto_delete": true
                }
            }
        },
        "php-fpm": {
            "name"          : "php-fpm",
            "platform_id"   : "standard-v2",
            "zone"          : "ru-central1-b",
            "cores"         : 2,
            "core_fraction" : 20,
            "is_nat"        : true,
            "preemptible"   : true,
            "memory"        : 1,
            "image_family"  : "debian-12",
            "boot_disk_size": 10
        }
    }
}
```

Full list of supported parameters for instances and their default values:
```
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
```