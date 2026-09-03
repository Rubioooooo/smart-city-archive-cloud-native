# Artifact Policy

This repository intentionally excludes several classes of files from
version control. This document explains what is excluded, why, and how
real environments are expected to supply these artifacts.

The `.gitignore` in this repository encodes these exclusions as precise
rules. Deliberately over-broad rules (for example `*.sql`, `config`,
`data/`, `bin/`, `*.yaml`) are avoided so that source code and
configuration remain trackable.

## Excluded Categories

### 1. Proprietary / business application binaries

Compiled business services, closed-source runtime components, and vendor
application packages are not distributed in a public repository: they are
licensed, revenue-bearing, or restricted assets. Deployment manifests
(Dockerfiles, Helm charts, Kubernetes resources) are kept so that the
deployment logic remains reviewable even when the binary itself is not
distributed here.

Generic examples: proprietary application packages, service binaries,
native libraries.

### 2. Production or real-record datasets

Database snapshots and captured production records must never enter
version control: they can contain personal or otherwise sensitive data,
and their size and churn make them unsuitable for a source repository.

Generic examples: `snap.sql`, `vehicle.sql`, `*.dump`, `*.sql.gz`.

### 3. Environment-specific credentials

Cluster credentials, client certificates and private keys, kubeconfig
files, and similar secret material are excluded without exception. Any
credential committed to Git must be treated as compromised and rotated.

Generic examples: `kubeconfig`, `kubeconfig.*`, `client-key*`, `*.key`,
`*.pem`.

### 4. Downloadable third-party tooling / build artifacts

Binaries and archives that can be fetched from their official sources are
not committed. Committing them bloats repository history and obscures
provenance and version pinning.

Generic examples: `kubectl`, `helm`, `yq_linux_amd64`, compiler archives
(`gcc-*.tar.gz`), runtime archives (`jdk*.tar.gz`,
`package_cuda*.tar.gz`, `perl.tgz`, `lib64.tgz`), package files
(`*.rpm`).

## Supplying Artifacts in Real Environments

Real deployments supply excluded artifacts through controlled channels:

- **Artifact repositories** — internal registries or repositories host
  proprietary binaries and pinned third-party tooling.
- **CI/CD artifact injection** — the pipeline downloads and injects
  artifacts at build or deploy time, so images and nodes receive exactly
  the pinned versions.
- **Secret/configuration management** — credentials and kubeconfig
  material are delivered through the platform's secret-management
  facility, never through Git.
- **Environment-specific deployment values** — environment-specific
  configuration is supplied as deployment values (for example Helm
  values, ConfigMaps, or Secrets) held outside the source tree.
