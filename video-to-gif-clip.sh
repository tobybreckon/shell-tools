#!/bin/bash
################################################################################

# convert a video file to a short high quality gif clip @ 10 fps

# Toby Breckon, Durham University, 2021

# acknowledgement: https://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality

################################################################################

if (test $# -ne 4)
then
  echo "usage: video-to-gif-clip.sh skipsecs length input output"
  echo
  echo "skipsecs = number of seconds to skip at start"
  echo "length = length of clip in secs"
  echo "input = path to input video"
  echo "output = path to output gif"
  echo
  
  exit 1
fi

################################################################################

ffmpeg -ss $1 -t $2 -i $3 -vf \
"fps=10,scale=0:0:flags=lanczos,split[s0][s1];[s0]palettegen=stats_mode=single[p];[s1][p]paletteuse=new=1" \
-loop 0 $4

echo
echo "$4 : $2 duration at 10 fps (original resolution)"

################################################################################
