#!/bin/bash
source config.shlib
helptxt() {
    echo '
 -h | вывод помощи по ключам
 -c | принять на вход конфиг
 -p | режим фотографирования
 -v | режим видеосъемки
 -s | режим стрима
 -o | файл
'
    echo 'Возможные устройства:'
    v4l2-ctl --list-devices
}
for i in $(seq 1 9); do
    if [ "${!i}" = "-c" ]; then
        i=$(( i + 1 ))
        a="${!i}"
        photo="$(config_get $a photo)"
        video="$(config_get $a video)"
        output="$(config_get $a output)"
    fi
done

if [ -z $device ] && [ -e $1 ]; then
    device=$1
    shift
else
    echo "Нужно ввести устройство"
fi
while [ -n "$1" ]; do
    case "$1" in
    -p) photo=true ;;
    -v) video=true ;;
    -o) output=$2
        shift ;;
    --) shift
        break ;;
    *) helptxt ;;
    esac
    shift
done

if [ $photo ] && [ $output ]; then
    ffmpeg -hide_banner -loglevel error -f v4l2 -i $device -vframes 1 $output
elif [ $photo ]; then
    ffmpeg -hide_banner -loglevel error -f v4l2 -i $device -vframes 1 photo.png

elif [ $video ] && [ $output ]; then
    echo 'Нажми q, чтобы завершить'
    ffmpeg -hide_banner -loglevel error -f v4l2 -r 30 -s 1920x1080 -i $device $output
elif [ $video ]; then
    echo 'Нажми q, чтобы завершить'
    ffmpeg -hide_banner -loglevel error -f v4l2 -framerate 30 -video_size 1920x1080 -i $device video.mp4
fi
