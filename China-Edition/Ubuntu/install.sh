#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 检查账户是否为root
if [ $(id -u) != "0" ]; then
    echo "错误: 你必须使用root账户运行此脚本！"
    exit 1
fi

echo "[+] 安装必须前置包和Redis"
apt-get install -y python-software-properties
apt-get install -y software-properties-common
add-apt-repository ppa:chris-lea/redis-server
apt-get update
apt-get install -y redis-server

echo "[+] 启动Redis进程"
systemctl start redis-server

echo "[+] 手动配置Redis密码"
while :;do
    Redis_Password=""
    read -p "请输入要给Redis设定的密码: " Redis_Password
    if [ "${Redis_Password}" = "" ]; then
        echo "错误：必须设定密码!!!"
    else
        break
    fi
done

echo "[+] 自动配置Redis"
echo "requirepass $Redis_Password" >> /etc/redis/redis.conf
echo "bind 127.0.0.1 ::1" >> /etc/redis/redis.conf
echo 'rename-command FLUSHALL ""' >> /etc/redis/redis.conf

echo "[+] 添加开机启动并重启Redis"
systemctl enable redis-server
service redis-server restart
