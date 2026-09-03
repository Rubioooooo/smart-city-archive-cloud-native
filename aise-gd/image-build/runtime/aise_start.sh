mkdir /home/idl-face/aise_1.0.29.1/aise-agent/data
echo 0 > /home/idl-face/aise_1.0.29.1/aise-agent/data/idxid
chown -R idl-face.idl-face /home/idl-face/aise_1.0.29.1


/bin/sh /home/idl-face/aise_1.0.29.1/bin/face-aise_control start
tail -f /home/idl-face/aise_1.0.29.1/logs/aise_service.log /home/idl-face/aise_1.0.29.1/logs/face-aise_control.log  &

# 程序的启动命令不支持在前台一直执行，可以写一个循环做健康检查
while true
do
    sleep 3
    ps aux |grep supervise.face-aise | grep -v grep &>/dev/null
    res1=$?
    ps aux |grep face-aise | grep -v supervise.face-aise |grep -v grep |grep -v tail &>/dev/null
    res2=$?
    if [ $res1 -ne 0 -o $res2 -ne 0 ];then
        echo "检测程序supervise.face-aise或face-aise服务异常，重新启动"
        /bin/sh /home/idl-face/aise_1.0.29.1/bin/face-aise_control stop
        /bin/sh /home/idl-face/aise_1.0.29.1/bin/face-aise_control start
    fi
done
