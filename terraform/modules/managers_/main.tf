variable "vmCount" {
  description = "Number of managers VM"
}
variable "ssh_pub_key" {
  description = "public ssh key"
}

resource "digitalocean_droplet" "managers" {
  count    = var.vmCount
  image    = "debian-10-x64"
  name     = "node-${count.index}"
  region   = "fra1"
  size     = "s-1vcpu-1gb"
  tags     = ["workshop"]
  user_data =  templatefile("./modules/managers/templates/cloud-init.tmpl", {
    ssh_pub_key = var.ssh_pub_key
  })
}

output "ip" {
  value = digitalocean_droplet.managers.*.ipv4_address
}
