while true;
do
    if [ -e /tmp/php.conf ] && [ -e /tmp/aise.conf ] && [ -e /tmp/feature.conf ] && [ -e /tmp/cluster.conf ];then
        echo "配置文件继续"
        break
    fi
    echo "配置文件未准备好！！！！！！！！！！"
    sleep 0.5
done
# 启动程序会修改php.conf，所以需要把configmap挂载到/tmp/php.conf的内容拷贝到/home/idl-face/odp/webserver/conf/vhost/php.conf
/usr/bin/cp /tmp/php.conf /home/idl-face/odp/webserver/conf/vhost/php.conf
/usr/bin/cp /tmp/aise.conf /home/idl-face/odp/conf/ral/services/aise.conf
/usr/bin/cp /tmp/feature.conf /home/idl-face/odp/conf/ral/services/feature.conf
/usr/bin/cp /tmp/cluster.conf /home/idl-face/odp/conf/db/cluster.conf
su - idl-face -c  "/home/idl-face/odp/hhvm/bin/hhvm_control start"
su - idl-face -c "/home/idl-face/odp/webserver/loadnginx.sh start"
tail -f /home/idl-face/odp/log/access_log /home/idl-face/odp/log/error_log /home/idl-face/odp/hhvm/status/hhvm/supervise.log &


(
while true
do
    sleep 5
    if [ `ps -ef|grep nginx|grep -v grep|wc -l` -lt 1 ];then 
        echo "nginx is shutdown, ready to restart"
        su - idl-face -c "/home/idl-face/odp/webserver/loadnginx.sh stop"
        su - idl-face -c "/home/idl-face/odp/webserver/loadnginx.sh start"
        if [ $? -eq 0 ];then
            echo "nginx is ok"
        else
            echo "nginx restart failed"
        fi
    fi
done
) &

# 异步删除组数据(业务需要)
(
while true;
do
    sleep $INTERVAL  # 该变量源自于values.yaml，然后在控制器的yaml中通过ENV注入
    /home/idl-face/odp/hhvm/bin/hhvm /home/idl-face/odp/app/face-api/script/DeleteGroup.php
done
) &

while true
do
    sleep 3
    ps aux |grep supervise.hhvm | grep -v grep &>/dev/null
    res1=$?
    ps aux |grep hhvm_bin | grep -v supervise.hhvm |grep -v grep |grep -v tail &>/dev/null
    res2=$?
    if [ $res1 -ne 0 -a $res2 -ne 0 ];then
        echo "检测程序supervise.hhvm与hhvm_bin服务均异常，重新启动"
        su - idl-face -c "/home/idl-face/odp/hhvm/bin/hhvm_control stop"
        su - idl-face -c "/home/idl-face/odp/hhvm/bin/hhvm_control start"
    fi
done
