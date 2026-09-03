# 可以查看cronjob的运行日志
[root@service-node.example.internal aise_gd_all_done]# kubectl  exec -ti aise-gd-cronjob-1650604440-vs4cj  sh
/ # tail -f /cronjob_logs/run.log

## Public repository build context

The topology-discovery job (aise-gd-cronjob) runs with a dedicated
utility image built from 镜像制作/job_dockerfile_dir/dockerfile.
That Dockerfile preserves the original containerization definition and
expects the following third-party executables in its build context:

- kubectl
- helm
- yq_linux_amd64

These third-party executables are intentionally not stored in Git.
In a controlled environment they are expected to be injected from an
artifact repository or the CI/CD build process.

The public repository does not provide fake placeholder binaries and
does not silently substitute unverified versions.
