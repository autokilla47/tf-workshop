variable "azure" {
  type = map
  description = "Azure credentials"
}
variable "google" {
  type = map
}
variable "digitalocean" {
  type = map
}

provider "azurerm" {
  version = "=2.12"
  features {}
  client_id       = var.azure.client_id
  subscription_id = var.azure.subscription_id
  tenant_id       = var.azure.tenant_id
  client_secret   = var.azure.client_secret

  skip_provider_registration = "true"
}


provider "google" {
  credentials = file(var.google.key)
  project     = var.google.project
  region      = var.google.region
}

provider "digitalocean" {
  token = var.digitalocean.token
}
