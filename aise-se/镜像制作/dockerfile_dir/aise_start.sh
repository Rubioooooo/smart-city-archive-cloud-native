
# 1、获取workload的副本数
get_replicas_num() {
    # 下述NAMESPACE来自于yaml中基于Downward API注入
	workload_name=$(/bin/kubectl -n $NAMESPACE get statefulsets.apps -l type=aise-se |awk 'NR>1{print $1}') 
	replicas=$(kubectl -n $NAMESPACE get statefulsets $workload_name -o jsonpath='{.spec.replicas}')
	
	echo $replicas
}

# 2、传入副本数，则生成切片号数组
generate_array() {
    local num=$1
    local result=()
    local i
    for ((i = 0; i < num; i++)); do
        result+=($(expr $i / 2))
    done
    echo "${result[@]}"  # (0 0 1 1 2 2 3)
}

# 3、获取自己的切片编号
get_partition_id() {
    # 1、依据副本数生成切片id数组，副本数从外部传入
	num=$1
	array=($(generate_array $num))
	#echo "${array[@]}" # (0 0 1 1 2 2 3)


	# 2、以pod名字的编号作为索引，从数组总取出自己的切片id
	index=`env |grep -i 'HOSTNAME'  | awk -F'-' '{print $NF}'`  # 变量HOSTNAME取自自动传入
	my_partition_id=${array[$index]}
	
	
	# 3、返回值
	echo $my_partition_id
}

# 4、修改配置文件：把configmap挂载到/tmp/aise.conf的内容拷贝到/home/idl-face/aise_1.0.29.1/conf/aise.conf，然后进行修改
handle_config() {
	my_partition_id=$1
	while true;
	do
		if [ -e /tmp/aise.conf ];then
			echo "/tmp/aise.conf存在"
			break
		fi
		echo "/tmp/aise.conf不存在！！！！！！！！！！"
		sleep 0.5
	done
	#configmap中只需要传入一个常规的aise-se的配置信息即可，然后会挂载到aise-se的/tmp目录下，每个aise-se在启动的时候会去/tmp下取出配置来进行定制化之后才会启动，后续的循环也会计算出该有的配置
	/usr/bin/cp /tmp/aise.conf /home/idl-face/aise_1.0.29.1/conf/aise.conf

	sed -ri "/physical_partition_id: 0/s@physical_partition_id: 0@physical_partition_id: $my_partition_id@g" /home/idl-face/aise_1.0.29.1/conf/aise.conf

}

# 5、启动/停止程序，并将程序日志输出到标准输出
start_app() {
	/bin/sh /home/idl-face/aise_1.0.29.1/bin/face-aise_control start
	tail -f /home/idl-face/aise_1.0.29.1/logs/aise_service.log /home/idl-face/aise_1.0.29.1/logs/face-aise_control.log  &
}

stop_app() {
	/bin/sh /home/idl-face/aise_1.0.29.1/bin/face-aise_control stop
	pkill -9 tail
}

# 6、初始化
init() {
	mkdir -p /home/idl-face/aise_1.0.29.1/aise-agent/data
	mkdir -p /home/idl-face/aise_1.0.29.1/{conf,logs}
	
	echo 0 > /home/idl-face/aise_1.0.29.1/aise-agent/data/idxid
}

# 7、检测
check() {
	while true
	do
		sleep 3
		ps aux |grep supervise.face-aise | grep -v grep &>/dev/null
		res1=$?
		ps aux |grep face-aise | grep -v supervise.face-aise |grep -v grep |grep -v tail &>/dev/null
		res2=$?
		if [ $res1 -ne 0 -a $res2 -ne 0 ];then
			echo "检测程序supervise.face-aise与face-aise服务均异常，重新启动"
			stop_app
			start_app
		fi
	done
}



# 8、主函数
main() {
    init
	
	replicas=$(get_replicas_num)
	my_partition_id=$(get_partition_id $replicas)
	handle_config $my_partition_id
	start_app
	
	
	check
}

main
