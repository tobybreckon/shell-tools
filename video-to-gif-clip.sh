#!/bin/bash
################################################################################

# convert a video file to a short high quality gif clip @ 10 fps

# Toby Breckon, Durham University, 2021

# acknowledgement: https://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality

################################################################################

if (test $# -ne 5)
then
  echo "Usage: video-to-gif-clip.sh skipsecs length scale input output"
  echo
  echo "skipsecs = number of seconds to skip at start"
  echo "length = length of clip in secs"
  echo "scale = scale factor for height and width (use 1 for no change)"
  echo "input = path to input video"
  echo "output = path to output gif"
  echo

  exit 1
fi

################################################################################

ffmpeg -ss $1 -t $2 -i $4 -vf \
"fps=10,scale=$3*in_w:$3*in_h:flags=lanczos,split[s0][s1];[s0]palettegen=stats_mode=single[p];[s1][p]paletteuse=new=1" \
-loop 0 $5

echo
echo "$5 : $2 duration at 10 fps ($3 x original resolution)"
mediainfo $5 | grep pixels
echo

################################################################################
