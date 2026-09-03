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

## Superarchive Business Layer

The superarchive business layer is the archive-facing application tier
of the platform. It consists of four independently deployable
components.

### High-Level Business Data Path

```text
Upstream archive data (abf datasource)
        |
        v
superarchive-sync ── synchronizes ──► superarchivev2 database
                                              ▲
superarchivev2-db-init ───── bootstraps ──────┘

superarchive-v2-exporter ──► ODP face-api
        └──────────────────► feature-frame (classification)
superarchive-v2-web ───────► ODP face-api

ODP
├── feature-frame
└── aise-gd
      └── aise-se
```

The superarchivev2 database is accessed on the same operator-managed
MySQL layer described above. The upstream abf datasource is an external
upstream system outside the scope of this repository.

### superarchivev2-db-init

superarchivev2-db-init is a one-shot `batch/v1` Job, not a long-running
application service. It bootstraps the archive database:

- waits for MySQL availability before initializing
- creates the superarchivev2 database and its tables if absent
- inserts configuration dictionaries (configuration rows only — it
  contains no production archive records)
- reuses the databus image family for its execution environment

### superarchive-sync

superarchive-sync is a long-running archive synchronization service:

- reads from the upstream abf datasource
- synchronizes snapshot data into the superarchivev2 database
- schedules the synchronization internally via Quartz
- carries Redis, Consul, and SFG-related integration configuration as
  present in its chart

### superarchive-v2-exporter

superarchive-v2-exporter is a business archive export/API service:

- exposes HTTP and brpc application interfaces
- integrates with the ODP face-api
- calls feature-frame's classification interface
- accesses the archive database and cache (Redis) dependencies

This component is a business/API exporter. It is NOT a Prometheus
metrics exporter, despite the historical directory/component name.

### superarchive-v2-web

superarchive-v2-web is the archive web application:

- integrates with the ODP face-api
- uses Redis
- its runtime includes GPU-related support and a native search
  dependency according to its existing deployment and image
  configuration

The web application integrates with ODP directly; it does not depend
on the exporter.

## Public Artifact Boundary

This repository contains deployable definitions and integration source.
Proprietary application runtimes, third-party binary build artifacts,
production/test datasets, and environment-specific
credentials/configuration are intentionally not stored in Git; they are
supplied by real environments externally according to
[docs/artifact-policy.md](artifact-policy.md).

The Dockerfiles preserve the original containerization definitions. Not
every image is independently buildable from this repository alone.
