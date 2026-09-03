# Architecture

## Repository Boundary

The overall project is split into two separate engineering boundaries:

### A. Smart City Archive Cloud-Native Deployment (this repository)

This repository handles:

- Business workload containerization
- Helm/Kubernetes deployment
- AISE workload topology
- Application service integration
- databus bootstrap

### B. MySQL Operator (separately maintained repository)

The MySQL infrastructure used by databus is provided by a separately
maintained MySQL Operator repository. That project covers MySQL cluster
lifecycle management, replication/runtime management, service
integration, and database availability management.

This repository does not contain the operator implementation; it
integrates with the MySQL layer that the operator provides.

## High-Level Data Path

```text
ODP
├── feature-frame
└── aise-gd
      └── aise-se

databus
  └── bridge
        └── relay
              └── aise-se
```

- **ODP** is the gateway/API-facing layer.
- **feature-frame** handles feature extraction workloads.
- **aise-gd** dispatches search requests according to shard topology.
- **aise-se** provides the sharded search-engine workloads.
- **bridge** consumes databus-side incremental data and forwards it to
  relay.
- **relay** buffers/distributes incremental state for aise-se.
- **databus** persists application data on the operator-managed MySQL
  layer.
