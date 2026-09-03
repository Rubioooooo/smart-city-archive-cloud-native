# FROM 采用的基础镜像
docker pull registry.example.com/public/deploy-base:centos7-gcc82

## Public repository build context

This Dockerfile preserves the original containerization definition.
Pinned third-party build artifacts and the proprietary feature
extraction runtime are intentionally not stored in Git.

External third-party build artifacts expected in the build context:

- psmisc-22.20-17.el7.x86_64.rpm
- perl.tgz
- coreutils-8.22-18.el7.x86_64.rpm

External proprietary runtime expected in the build context:

- aikl-face-package-1.3.5.1/ (feature extraction runtime)

In an actual build environment these artifacts are expected to be
injected from a controlled artifact repository or the CI/CD build
context.

The public repository does not create fake placeholder artifacts and
does not silently substitute unverified package versions.
