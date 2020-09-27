#!/bin/bash
if["$(uname)"=="Darwin"];then
    echo "MacOS脚本为测试脚本，我会让bash执行一些没用的命令，因为我不会延时"
    echo "如果你不想让你的设备用测试版脚本来安装NodeBB请在输出到16之前结束本脚本"
    echo "1"
    echo "2"
    echo "3"
    echo "4"
    echo "5"
    echo "6"
    echo "7"
    echo "8"
    echo "9"
    echo "10"
    echo "11"
    echo "12"
    echo "13"
    echo "14"
    echo "15"
    echo "16"
    echo "在指定次数内没有结束，继续执行"
    sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    echo "脚本未完工，暂时只安装brew"
elif["$(expr substr $(uname -s) 1 5)"=="Linux"];then   
    if [ $(id -u) != "0" ]; then
        echo "[#] 错误: 你必须使用root权限运行本脚本！"
        exit 1
    fi
    ## DISTRO是系统发行版名称，PM为指定的包管理器
    echo "[#] 检测系统发行版和指定包管理器"
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux" /etc/issue || grep -Eq "Red Hat Enterprise Linux" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Arch Linux" /etc/issue || grep -Eq "Arch Linux" /etc/*-release; then
        DISTRO='Arch'
        PM='pacman'
    elif grep -Eqi "Manjaro Linux" /etc/issue || grep -Eq "Manjaro" /etc/*-release; then
        DISTRO='Manjaro'
        PM='pacman'
    else
        DISTRO='Unknown'
    fi
fi
