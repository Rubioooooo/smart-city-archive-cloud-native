(
while true;
do  
    cd /home/idl-face/relay/log/
    if [ -e ./relay.INFO ] && [ -e ./relay_ub.log ] && [ -e ./sync-log/sync.index ];then
        break
    else
        sleep 1
    fi
done

tail -f /home/idl-face/relay/log/relay.INFO /home/idl-face/relay/log/relay_ub.log /home/idl-face/relay/log/sync-log/sync.index
) &

/bin/sh /home/idl-face/relay/bin/relay.sh start

while true
do
    sleep 3
    ps aux |grep supervise.relay | grep -v grep &>/dev/null
    res1=$?
    ps aux |grep relay_server | grep -v supervise.relay |grep -v grep &>/dev/null
    res2=$?
    if [ $res1 -ne 0 -a $res2 -ne 0 ];then
        echo "检测程序supervise.relay与relay_server均异常，重新启动"
        pkill -9 supervise.relay
        pkill -9 relay_server
        /bin/sh /home/idl-face/relay/bin/relay.sh start
    fi
done
