#!/bin/bash
if["$(uname)"=="Darwin"];then
    echo "暂不支持MacOS安装"
elif["$(expr substr $(uname -s) 1 5)"=="Linux"];then   
    if [ $(id -u) != "0" ]; then
        echo "[#] 错误: 你必须使用root权限运行本脚本！"
        exit 1
    fi
fi
