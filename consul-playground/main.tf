# Specify the Consul provider source and version
terraform {
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "2.14.0"
    }
  }
}

# Configure the Consul provider
provider "consul" {
  address    = "localhost:8500"
  datacenter = "dc1"

  # SecretID from the previous step
  token      = "YOUR_BOOTSTRAP_TOKEN_HERE"
}
