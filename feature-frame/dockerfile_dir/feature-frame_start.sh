#!/bin/bash

/bin/sh /home/idl-face/aikl-face-package-1.3.5.1/bin/face-general-service_control start


while true
do
    sleep 3
    ps aux |grep supervise.face-general-service | grep -v grep &>/dev/null
    res1=$?
    ps aux |grep face-general-service | grep -v supervise.face-general-service |grep -v grep |grep -v tail &>/dev/null
    res2=$?
    if [ $res1 -ne 0 -a $res2 -ne 0 ];then
        echo "检测程序supervise.face-general-service与face-general-service服务均异常，重新启动"
        /bin/sh /home/idl-face/aikl-face-package-1.3.5.1/bin/face-general-service_control stop
        /bin/sh /home/idl-face/aikl-face-package-1.3.5.1/bin/face-general-service_control start
    fi
done
