#!/bin/bash

# 内部联调用测试数据初始化脚本。
# 注意：其中设备/摄像头信息（名称、设备ID、RTSP地址、国标编码等）均为示例占位符，非真实数据。

ip=127.0.0.1
port=32031
user=root
pass=xxxx


mysql -u$user -p$pass -h $ip -P $port -e "create database abf;use abf;source ./sql/snap.sql;source ./sql/vehicle.sql;"
if [ $? -eq 0 ];then
    echo "sql导入成功"
fi

for id in 1 11 13 17 2 7 8 9 32
do
mysql -u$user -p$pass -h $ip -P $port -e "INSERT INTO superarchivev2.arch_third_party_devices(id, area, camera_account, camera_brand, camera_ip, camera_name, camera_password, device_id, height, info, output_video_url, owner_id, port, rtsp_url, status, width, scene_id, gb_id, access_type, type, created_by, created_date, last_modified_by, last_modified_date, last_sync_at, latitude, manufactor_code, model, function_type, longitude) VALUES ($id, NULL, NULL, 'kedacom', NULL, 'test_camera_example_001', NULL, 'test-device-0001', NULL, NULL, NULL, NULL, NULL, 'kedasdk://testuser:testpass@192.0.2.50:80/test-channel-0001/test-device-0001@szga/0', 'HEALTHY', NULL, 10048, '10000000001000000100', 'DIRECT', 'VIDEO', NULL, NULL, 'testuser', '2021-04-25 05:00:23', NULL, NULL, NULL, NULL, NULL, NULL);" &>/dev/null
done
echo "数据插入完毕，结果如下"
mysql -u$user -p$pass -h $ip -P $port -e "select id,camera_brand,camera_name from superarchivev2.arch_third_party_devices;"
