# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

acl = "read"
agent_prefix "" {
	policy = "read"
}
event_prefix "" {
	policy = "read"
}
key_prefix "" {
	policy = "read"
}
keyring = "read"
node_prefix "" {
	policy = "write"
}
operator = "read"
query_prefix "" {
	policy = "read"
}
service_prefix "" {
	policy = "read"
	intentions = "read"
}
session_prefix "" {
	policy = "read"
}
