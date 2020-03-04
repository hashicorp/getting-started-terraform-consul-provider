provider "consul" {
  address    = "localhost:8500"
  datacenter = "dc1"
  token      = "<ACL_TOKEN_HERE>"
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
  name = "counting-service"
  node = consul_node.counting.name
  port = 9001
  tags = ["counting"]

  check {
    check_id        = "service:counting"
    name            = "Counting health check"
    status          = "passing"
    http            = "localhost:9001"
    tls_skip_verify = false
    method          = "GET"
    interval        = "5s"
    timeout         = "1s"
  }
}

# Register Dashboard Service
resource "consul_service" "dashboard" {
  name = "dashboard-service"
  node = consul_node.dashboard.name
  port = 8080
  tags = ["dashboard"]

  check {
    check_id        = "service:dashboard"
    name            = "Dashboard health check"
    status          = "passing"
    http            = "localhost:8080"
    tls_skip_verify = false
    method          = "GET"
    interval        = "5s"
    timeout         = "1s"
  }
}

# List all services
data "consul_services" "dc1" {}

output "consul_services_dc1" {
  value = data.consul_services.dc1
}

# List counting service information
data "consul_service" "counting" {
  name = consul_service.counting.name
}

output "counting_ports" {
  value = data.consul_service.counting
}

# List Consul agent node address and ports
data "consul_service" "agents" {
  name = "consul"
}

output "consul_agents_address_ports" {
  value = {
    for service in data.consul_service.agents.service :
    service.node_id => join(":", [service.node_address, service.port])
  }
}
