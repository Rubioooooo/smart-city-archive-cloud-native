/bin/sh /home/idl-face/public_bridge/update-pos.sh
/bin/sh /home/idl-face/public_bridge/bin/bridge.sh start


while true
do
    sleep 3
    ps aux |grep supervise.bridge | grep -v grep &>/dev/null
    res1=$?
    ps aux |grep bridge | grep -v supervise.bridge |grep -v grep &>/dev/null
    res2=$?
    if [ $res1 -ne 0 -a $res2 -ne 0 ];then
        echo "检测程序supervise.bridge与bridge服务均异常，重新启动"
        /bin/sh /home/idl-face/relay/bin/bridge.sh stop
        /bin/sh /home/idl-face/relay/bin/bridge.sh start
    fi
done

