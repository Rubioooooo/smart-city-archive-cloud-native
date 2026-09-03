# 验证最终结果: face_test是封装在pod内/usr/bin/face_test的命令，调用的是一个python写的测试脚本
# 1、 获取odp-service的ip与端口填在后面，一定要用IP地址
[root@service-node.example.internal odp_all_done]# kubectl  get svc -o wide |grep odp
odp-service                                    NodePort    192.0.2.28   <none>        8400:8400/TCP                44s     app=odp

# 2、执行
kubectl exec -ti odp-deployment-6bffdcd67f-8gggd  face_test 192.0.2.28 8400

## Public repository build context

This Dockerfile preserves the original containerization definition.
The proprietary gateway runtime and pinned third-party build
artifacts are intentionally not stored in Git.

External proprietary runtime expected in the build context:

- odp/ (PHP/HHVM gateway application tree)

External third-party build artifact expected in the build context:

- net-tools-2.0-0.25.20131004git.el7.x86_64.rpm

In an actual build environment these artifacts are expected to be
supplied through a controlled artifact repository or CI/CD build-time
artifact injection.

The public repository does not provide fake placeholder artifacts and
does not substitute unverified package versions.

## Environment-specific runtime configuration

The odp chart requires a ConfigMap key named cluster.conf:

- the Deployment mounts it (subPath /tmp/cluster.conf)
- the startup script waits for /tmp/cluster.conf and copies it to the
  runtime DB cluster routing location

cluster.conf contains environment-specific database cluster routing
configuration. Its actual topology is intentionally not populated in
this public repository. Deployment environments must provide the
appropriate cluster.conf content when installing the odp chart.
