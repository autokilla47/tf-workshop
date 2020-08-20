variable "vmCount" {
  type = number
  description = "Number of VM"
}

variable "ssh_pub_key" {
  type = string
  description = "public ssh key"
}

variable "zone" {
  type = string
  description = "Data center location"
  default = "europe-west3-a"
}

variable "name" {
  type = string
  description = "VM name"
  default = "instance"
}

variable "tags" {
  type = list(string)
  description = "Tags"
  default = ["some-tag"]
}
