# Smart City Archive Cloud-Native Deployment

This repository contains the cloud-native deployment and infrastructure
integration for a smart-city archive platform.

## Engineering Areas

The deployment work in this repository covers:

- Docker-based application containerization
- Kubernetes workloads
- Helm charts
- Stateful workloads
- AISE dynamic shard topology
- Service discovery
- Configuration management
- GPU workload scheduling
- Data initialization
- Operational automation

## Repository Scope

The project scope covered by this repository includes:

- aise-gd
- aise-se
- odp
- feature-frame
- bridge
- relay
- superarchive application services
- databus application-side bootstrap/integration

This section describes the project scope. It does not imply that every
listed component has already been committed to Git.

## Databus and the MySQL Operator Boundary

databus is the platform data service. The `databus-data-init-job-chart/`
directory in this repository contains the application-side database/schema
bootstrap and deployment integration for databus.

The databus database layer is backed by a separately maintained MySQL
Operator project. This repository contains the application-side bootstrap
and deployment integration for databus, while MySQL cluster lifecycle and
database availability capabilities are maintained in the operator
repository.

## Public Artifact Boundary

Some proprietary/business runtime binaries, production datasets,
credentials, and environment-specific configuration are intentionally
excluded from this public repository. See
[docs/artifact-policy.md](docs/artifact-policy.md) for what is excluded,
why, and how real environments are expected to supply it.

Deployment manifests and containerization logic are preserved even when
the corresponding proprietary runtime artifact is not distributed in this
repository.
