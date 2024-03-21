# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Specify the Consul provider source and version
terraform {
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "2.20.0"
    }
  }
}

# Configure the Consul provider
provider "consul" {
  address    = "localhost:8500"
  datacenter = "dc1"

  # SecretID from the previous step
  token      = "<SECRED_ID_HERE>"
}

# Register external node - counting
resource "consul_node" "counting" {
  name    = "counting"
  address = "localhost"

  meta = {
    "external-node"  = "true"
    "external-probe" = "true"
  }
}

# Register external node - dashboard
resource "consul_node" "dashboard" {
  name    = "dashboard"
  address = "localhost"

  meta = {
    "external-node"  = "true"
    "external-probe" = "true"
  }
}

# Register Counting Service
resource "consul_service" "counting" {
  name    = "counting-service"
  node    = consul_node.counting.name
  port    = 9001
  tags    = ["counting"]

  check {
    check_id                          = "service:counting"
    name                              = "Counting health check"
    status                            = "passing"
    http                              = "localhost:9001"
    tls_skip_verify                   = false
    method                            = "GET"
    interval                          = "5s"
    timeout                           = "1s"
  }
}

# Register Dashboard Service
resource "consul_service" "dashboard" {
  name    = "dashboard-service"
  node    = consul_node.dashboard.name
  port    = 8080
  tags    = ["dashboard"]

  check {
    check_id                          = "service:dashboard"
    name                              = "Dashboard health check"
    status                            = "passing"
    http                              = "localhost:8080"
    tls_skip_verify                   = false
    method                            = "GET"
    interval                          = "5s"
    timeout                           = "1s"
  }
}

# List all services
data "consul_services" "dc1" {}

output "consul_services_dc1" {
    value = data.consul_services.dc1
}


# Exported Services Demo
resource "consul_admin_partition" "ap1" {
  name = "ap1"
}

resource "consul_config_entry_v2_exported_services" "counting" {
  kind = "ExportedServices"
  name = "exported-counting"
  partition = "default"
  partition_consumers = ["ap1"]
  services = ["counting-service"]
}

resource "consul_config_entry_v2_exported_services" "dash" {
  kind = "ExportedServices"
  name = "exported-dash"
  partition = "default"
  partition_consumers = ["ap1"]
  services = ["dashboard-service"]
}

resource "consul_admin_partition" "ap2" {
  name = "ap2"
}

resource "consul_config_entry_v2_exported_services" "ns" {
  kind = "NamespaceExportedServices"
  name = "exported-ns"
  namespace = "default"
  partition = "default"
  partition_consumers = ["ap2"]
}

resource "consul_admin_partition" "ap3" {
  name = "ap3"
}

resource "consul_config_entry_v2_exported_services" "part" {
  kind = "PartitionExportedServices"
  name = "exported-part"
  partition = "default"
  partition_consumers = ["ap3"]
}
