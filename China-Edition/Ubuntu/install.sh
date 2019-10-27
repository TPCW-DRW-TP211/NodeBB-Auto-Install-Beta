#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 检查账户是否为root
if [ $(id -u) != "0" ]; then
    echo "错误: 你必须使用root账户运行此脚本！"
    exit 1
fi

echo "[+] 安装必须前置包"
apt-get update
apt-get install -y git build-essential
apt-get install -y python-software-properties
apt-get install -y software-properties-common
apt-get update
add-apt-repository -y ppa:chris-lea/redis-server
apt-get update

echo "[+] 安装NVM并安装/配置nodejs"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
sleep 5
source ~/.bashrc && echo "1"
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
export NVM_IOJS_ORG_MIRROR=https://npm.taobao.org/mirrors/iojs
sleep 5
source ~/.bashrc && echo "1"
nvm install --lts
node -v
npm -v
npm config set registry https://registry.npm.taobao.org
sleep 5
source ~/.bashrc && echo "1"
systemctl enable nodejs
systemctl enable npm

echo "[+] 安装Redis"
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

echo "[+] 获取并安装NodeBB"
cd /home/
git clone -b v1.12.x https://github.com/NodeBB/NodeBB.git /home/nodebb
cd nodebb/
echo "[#] 需要手动到http://服务器公网IP:4567进行网页配置"
sleep 15
source ~/.bashrc
echo "[+] 配置进程开始"
./nodebb install
./nodebb start

echo "[+] 设置NodeBB开机自启"
adduser --system --group nodebb
chown -R nodebb:nodebb /home/nodebb
echo '[Unit]' > /lib/systemd/system/nodebb.service
echo 'Description=NodeBB Forum For Node.js.' >> /lib/systemd/system/nodebb.service
echo 'Documentation=http://nodebb.readthedocs.io/en/latest/' >> /lib/systemd/system/nodebb.service
echo 'After=system.slice multi-user.target' >> /lib/systemd/system/nodebb.service
echo "" >> /lib/systemd/system/nodebb.service
echo '[Service]' >> /lib/systemd/system/nodebb.service
echo 'Type=simple' >> /lib/systemd/system/nodebb.service
echo 'User=nodebb' >> /lib/systemd/system/nodebb.service
echo "" >> /lib/systemd/system/nodebb.service
echo 'StandardOutput=syslog' >> /lib/systemd/system/nodebb.service
echo 'StandardError=syslog' >> /lib/systemd/system/nodebb.service
echo 'SyslogIdentifier=nodebb' >> /lib/systemd/system/nodebb.service
echo "" >> /lib/systemd/system/nodebb.service
echo 'Environment=NODE_ENV=production' >> /lib/systemd/system/nodebb.service
echo 'WorkingDirectory=/home/nodebb' >> /lib/systemd/system/nodebb.service
echo 'ExecStart=/usr/bin/node loader.js --no-daemon --no-silent' >> /lib/systemd/system/nodebb.service
echo '#请修改/usr/bin/node 为which node所打印的位置' >> /lib/systemd/system/nodebb.service
echo 'Restart=always' >> /lib/systemd/system/nodebb.service
echo "" >> /lib/systemd/system/nodebb.service
echo '[Install]' >> /lib/systemd/system/nodebb.service
echo 'WantedBy=multi-user.target' >> /lib/systemd/system/nodebb.service
systemctl enable nodebb

echo "[#] 如果完成了网页配置，那么本次自动配置完成，网页Nginx代理(映射4567端口)请自行设置，或等待作者写完NodeBB映射配置"
echo "[#] TPLAPETA Inc. - DragonRiverWorld INT Automaic Script - By.TP211 - OpenSource Pubilc"
echo "[#] 本脚本作者：TP211 配置完成 结束进程"
exit 0
