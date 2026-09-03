# FROM 采用的基础镜像
docker pull registry.example.com/public/deploy-base:centos7-gcc

## Public repository build context

This Dockerfile preserves the original containerization definition.
Some runtime and third-party build artifacts are intentionally not
stored in Git.

Required external build-context artifacts include:

- coreutils-8.22-18.el7.x86_64.rpm
- psmisc-22.20-17.el7.x86_64.rpm
- MySQL client binary named `mysql`
- proprietary `public_bridge/` runtime tree

In an actual build environment these artifacts are expected to be
supplied through a controlled artifact repository or CI/CD build-time
artifact injection.

The public repository does not provide placeholder binaries and does
not substitute unverified package versions.

