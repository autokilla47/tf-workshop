locals {
  ssh_pub_key = file("~/.ssh/id_rsa.pub")
}

module "workers" {
  source      = "./modules/instances"
  vmCount     = 2
  zone        = "europe-west3-a"
  ssh_pub_key = local.ssh_pub_key
  name        = "worker"
  tags        = ["workshop", "worker"]
}

module "managers" {
  source      = "./modules/instances"
  vmCount     = 1
  zone        = "europe-west3-a"
  ssh_pub_key = local.ssh_pub_key
  name        = "manager"
  tags        = ["workshop", "manager"]
}

module "dns" {
  source      = "./modules/dns"
  domain      = "w.clsv.ru"
  group_name  = var.azure.group_name
  records     = {
    workers = module.workers.ip
    managers = module.managers.ip
  }
}

resource "local_file" "inventory" {
  content =  templatefile("./templates/inventory.yaml.tmpl", {
    workers = module.workers.ip
    managers = module.managers.ip
    manager_main = module.managers.ip[0]
  })
  filename = "../inventory/hosts.yaml"
}

# module "windowsservers" {
#   source              = "Azure/compute/azurerm"
#   resource_group_name = azurerm_resource_group.example.name
#   is_windows_image    = true
#   vm_hostname         = "mywinvm" // line can be removed if only one VM module per resource group
#   admin_password      = "ComplxP@ssw0rd!"
#   vm_os_simple        = "WindowsServer"
#   public_ip_dns       = ["winsimplevmips"] // change to a unique name per datacenter region
#   vnet_subnet_id      = module.network.vnet_subnets[0]
# }