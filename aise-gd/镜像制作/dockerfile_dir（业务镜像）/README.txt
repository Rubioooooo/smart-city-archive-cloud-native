# FROM 采用的基础镜像
docker pull registry.example.com/public/deploy-base:centos7-gcc82

# 物理主机必须开启
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf && sysctl -p

## Public repository build context

This Dockerfile preserves the original containerization definition.
Pinned third-party build artifacts and the proprietary AISE runtime
are intentionally not stored in Git.

External third-party build artifacts expected in the build context:

- psmisc-22.20-17.el7.x86_64.rpm
- net-tools-2.0-0.25.20131004git.el7.x86_64.rpm
- coreutils-8.22-18.el7.x86_64.rpm
- gcc-4.8.2.tar.gz

External proprietary runtime expected in the build context:

- aise_1.0.29.1 (AISE dispatcher runtime)

In an actual build environment these artifacts are expected to be
supplied through a controlled artifact repository or CI/CD build-time
artifact injection.

The public repository does not provide placeholder binaries and does
not substitute unverified package versions.
