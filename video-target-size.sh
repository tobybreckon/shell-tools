#!/bin/bash
################################################################################

# compress a video file to a target size in MB (for online submissions etc)

# Toby Breckon, Durham University, 2020

# acknowledgement: https://stackoverflow.com/questions/29082422/ffmpeg-video-compression-specific-file-size

################################################################################

if (test $# -ne 2)
then
  echo "usage: video-target-size.sh video size"
  echo "video = video file"
  echo "size = size in MB (integer or float)"
  exit 1
fi

################################################################################

# target_video_bitrate_kbit_s=$(\
#    awk \
#    -v size="$target_video_size_MB" \
#    -v duration="$origin_duration_s" \
#    -v audio_rate="$target_audio_bitrate_kbit_s" \
#    'BEGIN { print  ( ( size * 8192.0 ) / ( 1.048576 * duration ) - audio_rate ) }')

 target_video_bitrate_kbit_s="$(awk "BEGIN {print int($2 * 1024 * 1024 * 8 / $(ffprobe \
    -v error \
    -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 \
    "$1" \
) / 1000)}")"

################################################################################

# N.B. cutting out audio in 2 pass processing

ffmpeg \
    -y \
    -i "$1" \
    -c:v libx264 \
    -b:v "$target_video_bitrate_kbit_s"k \
    -pass 1 \
    -an \
    -f mp4 \
    /dev/null \
&& \
ffmpeg \
    -i "$1" \
    -c:v libx264 \
    -b:v "$target_video_bitrate_kbit_s"k \
    -pass 2 \
    -an \
    "${1%.*}-$2mB.mp4"

################################################################################
