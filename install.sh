#!/usr/bin/env bash

os=$(lsb_release -i)
getKernel() {
    if [[ $(uname -r) =~ "zen" ]]; then
        kernel=linux-zen-headers
    elif [[ $(uname -r) =~ "lts" ]]; then
        kernel=linux-lts-headers
    else
        kernel=linux-headers
    fi
}

read -p "Нужны будут права администратора, вы согласны? [Y/n] " admin
if [[ $admin == "n" ]]; then
    exit 0
fi

if [[ $os =~ "Ubuntu" ]] || [[ $os =~ "Debian" ]]; then
    sudo apt-get install ffmpeg v4l-utils v4l2loopback-dkms linux-headers
elif [[ $os =~ "Arch" ]] || [[ $os =~ "Mangaro" ]] || [[ $os =~ "Endeavour" ]]; then
    getKernel
    sudo pacman -Sy --needed ffmpeg v4l-utils v4l2loopback-dkms $kernel
else
    echo "Твоя система еще не поддерживается скриптом"
fi
read -p "Хотите перезагрузиться сейчас или сделать это позже? [y/N]: " reboot
read -p "После перезагрузки необходимо будет прописать \"sudo modprobe v4l2loopback\""
if [[ $reboot == "y" ]]; then
    reboot
fi
