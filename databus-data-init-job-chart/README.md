# data-init Helm Chart

# 1  介绍
此chart的主要功能是初始化mysql的数据库和consul数据库,里面包含两个job,运行此chart需要保证机器上已经安装好mysql和consul,否则数据初始化会失败

# 2 sql文件更改的数据更新
  如果mysql的sql数据发生变化,则需要更新对应的configmap文件,在templates目录下,每个服务都有自己的configmap文件,比如abf的configmap文件为abf-init-configmap.yaml
  可以直接修改里面的sql语句,也可以通过sql语句来使用k8s的命令来自动生成configmap文件

  ```
  kubectl create configmap abf-init --from-file=abf-init.sql 

  kubectl get configmap abf-init -o yaml >> abf-init-configmap.yaml
  
  kubectl create configmap asc-init --from-file=asc-init.sql 

  kubectl get configmap asc-init -o yaml >> asc-init-configmap.yaml
  
  ```
  将生成的confimap文件替换现有的文件即可

# 3 关于发布版本
 如果新初始化数据可以直接兼容以前的数据，可以直接在主干master上更新，作为主干的迭代分支。如果初始化数据为地方部署特有数据，不前后兼容，则新建分支，将数据替换到分支上，
 然后新建流水线进行chart的版本发布。