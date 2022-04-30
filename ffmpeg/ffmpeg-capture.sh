#!/bin/bash
FILEPATH=$(date +"$HOME/videos/ffmpeg/%Y/%m/%d")
mkdir -p ${FILEPATH}
FILENAME=$(date +"capture_x264_%T.mkv")
ffmpeg \
    -s 1920x1080 -r 30 \
    -f x11grab -follow_mouse centered -i $DISPLAY \
    -f alsa -i hw:1,0 \
    -c:v libx264 \
    ${FILEPATH}/${FILENAME}
