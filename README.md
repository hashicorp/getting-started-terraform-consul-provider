# Getting Started with Terraform Consul Provider

## Overview
This repo contains the `docker-compose.yml` necessary to spin up a Consul DC and counting/dashboard service.

This is used both for local development and Katacoda Scenario.

The ACL setup via docker compose was inspired by: https://github.com/tsurubee/consul-acl-playground

## Workspace

This workspace contains the following:

- simple Consul datacenter running with ACL pre-configured (UI on port :8500):
   - 3 Consul servers
   - 2 Consul clients
- Counting service running on port :9001
- Dashboard for counting service running on port :8080

### Usage
#### How to use Docker containers
Start up containers.  
```
$ docker-compose up -d
Starting consul-playground_consul-server-1 ... done
Starting consul-playground_consul-agent_1  ... done
```

#### Bootstrapping ACL
Run the following command to view the Master ACL Token.
```
$ docker exec -it consul-playground_consul-server-1_1 consul acl bootstrap
AccessorID:   8bd3c315-9155-57d7-a22f-451665f71154
SecretID:     4ec60a89-abaa-fda9-46c1-e6e174094a97
Description:  Bootstrap Token (Global Management)
Local:        false
Create Time:  2018-12-02 06:44:09.0256574 +0000 UTC
Policies:
   00000000-0000-0000-0000-000000000001 - global-management
```

Then, you can run the consul command with token like below.  
```
$ docker exec -it consul-playground_consul-server-1_1 consul members -token=<TOKEN>
Node             Address           Status  Type    Build  Protocol  DC       Segment
consul-server-1  192.168.0.2:8301  alive   server  1.4.0  2         test-dc  <all>
consul-agent-1   192.168.0.3:8301  alive   client  1.4.0  2         test-dc  <default>
```

#### Setting up Consul ESM

To set up and run consul-esm, you need to assign the master ACL token in the esm-config.hcl file. The consul-esm binary has already been downloaded and unzipped in the server binary.
```
$ docker exec -it consul-playground_consul-server-1_1 sh -c "echo 'token = \"<TOKEN>\"' > esm-config.hcl"
```

Then, run the following command. this should initialize consul-esm and automatically register any external nodes.
```
$ docker exec -itd consul-playground_consul-server-1_1 sh -c "./consul-esm -config-file=esm-config.hcl"
2020/03/04 20:11:17 [INFO] Connecting to Consul on 127.0.0.1:8500...
Consul ESM running!
            Datacenter: (default)
               Service: "consul-esm"
           Service Tag: ""
            Service ID: "consul-esm:09be447c-2585-4891-474c-9d17875cbab2"
Node Reconnect Timeout: "72h0m0s"

Log data will now stream in as it occurs:

2020/03/04 20:11:17 [INFO] Trying to obtain leadership...
2020/03/04 20:11:17 [INFO] Obtained leadership
2020/03/04 20:11:17 [INFO] Caught signal: window changed
2020/03/04 20:11:18 [INFO] Rebalanced 0 external nodes across 1 ESM instances
```