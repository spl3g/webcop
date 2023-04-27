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

read -p "Загрузить скрипт? [Y/n] " scr
read -p "Установить зависимости? [Y/n] " dep

if [[ $scr == "y" ]] || [[ $scr == "Y" ]] || [[ -z $scr ]]; then
    echo "Загрузка скрипта..."
    git clone https://github.com/spl3g/webcop.git
    cd webcop
    chmod +x webcop
fi

if [[ $dep == "y" ]] || [[ $dep == "Y" ]] || [[ -z $dep ]]; then
    echo "Установка зависимостей..."
    read -p "Нужны будут права администратора, вы согласны? [Y/n] " admin
    if [[ $admin == "n" ]] || [[ $admin == "N" ]]; then
        exit 0
    fi

    if [[ $os =~ "Ubuntu" ]] || [[ $os =~ "Debian" ]]; then
        sudo apt-get install ffmpeg v4l-utils v4l2loopback-dkms linux-headers
    elif [[ $os =~ "Arch" ]] || [[ $os =~ "Manjaro" ]] || [[ $os =~ "Endeavour" ]]; then
        getKernel
        sudo pacman -Sy --needed ffmpeg v4l-utils v4l2loopback-dkms $kernel
    else
        echo "Ваша система еще не поддерживается скриптом"
    fi
    echo "v4l2loopback" | sudo tee /etc/modules-load.d/v4l2loopback.conf
fi

read -p "Хотите перезагрузиться сейчас? [y/N]: " reboot
if [[ $reboot == "y" ]] || [[ $reboot == "Y" ]]; then
    echo "Перезагружаемся"
    reboot
fi
