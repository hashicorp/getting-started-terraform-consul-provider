# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

FROM hashicorppreview/consul-enterprise:1.18-dev

COPY . /etc/consul.d

ADD https://releases.hashicorp.com/consul-esm/0.3.3/consul-esm_0.3.3_linux_amd64.zip .
RUN unzip consul-esm_0.3.3_linux_amd64.zip