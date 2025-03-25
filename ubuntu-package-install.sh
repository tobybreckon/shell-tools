#!/bin/sh

################################################################################

# install a number of esoteric packages on Ubuntu 22.04 and later
# (semi-automatically without having to web search each set of commands)

# Toby Breckon, Durham University, Jan 2024

################################################################################

TMPDIR=$(mktemp -d)
cd $TMPDIR

################################################################################

case $1 in

  repos)
    sudo add-apt-repository universe
    sudo add-apt-repository multiverse
    sudo apt update
    ;;

  chrome)

    # google chrome browser

    wget https://dl-ssl.google.com/linux/linux_signing_key.pub
    sudo apt-key add linux_signing_key.pub
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

    sudo apt-get install google-chrome-stable
    ;;

  zoom)

    # zoom video conf

    wget https://zoom.us/client/latest/zoom_amd64.deb
    sudo apt install ./zoom_amd64.deb
    ;;

  vscode)

    # MS VS code editor

    wget https://packages.microsoft.com/keys/microsoft.asc
    sudo apt-key add microsoft.asc
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install code
    ;;

  edge)

    # MS edge browser
    
    wget https://packages.microsoft.com/keys/microsoft.asc
    sudo apt-key add microsoft.asc
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/edge.list'
    sudo apt update
    sudo apt install microsoft-edge-stable
    ;;

  f5vpn)

    # f5 networks VPN solution - GUI + CLI

    wget https://access.durham.ac.uk/public/download/linux_f5vpn.x86_64.deb
    wget https://access.durham.ac.uk/public/download/linux_f5cli.x86_64.deb
    sudo apt install ./linux_f5*.deb
    ;;

  slack)

    # slack 

    wget -q https://slack.com/downloads/instructions/ubuntu -O - \
    | tr "\t\r\n'" '   "' \
    | grep -i -o '<a[^>]\+href[ ]*=[ \t]*"\(ht\|f\)tps\?:[^"]\+"' \
    | sed -e 's/^.*"\([^"]\+\)".*$/\1/g' \
    | grep 'slack-desktop' \
    | xargs wget -q -O slack-desktop-latest.deb
    sudo apt install ./slack-desktop-latest.deb
    ;;

  ximea)

    # ximea camera drivers - for OpenCV build

    wget https://www.ximea.com/downloads/recent/XIMEA_Linux_SP.tgz
    tar xzf XIMEA_Linux_SP.tgz
    cd package
    sudo ./install
    ;;

  cuda)

    # nvidia cuda - full stack

    sudo apt install nvidia-cuda-toolkit
    ;;

  cudnn)

    # nvidia cuCNN deep learning base library

    sudo apt install nvidia-cudnn
  
    ;;

  opencv-extras)

   # additional packages required for fully functional OpenCV build from source

    sudo apt update
    sudo apt upgrade

    sudo apt install \
    build-essential \
    checkinstall  \
    clpeak \
    cmake \
    doxygen \
    ffmpeg \
    g++-9 \
    gcc-9 \
    gfortran \
    git \
    libatlas-base-dev \
    libavcodec-dev \
    libavformat-dev \
    libswresample-dev \
    libeigen3-dev \
    libfaac-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libgphoto2-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgtk-3-dev \
    libhdf5-dev \
    libjpeg-dev \
    liblapacke64-dev \
    liblapacke-dev \
    libmp3lame-dev \
    libopenblas-dev \
    libpng-dev \
    libprotobuf-dev \
    libswscale-dev \
    libtbb-dev \
    libtheora-dev \
    libtiff-dev \
    libv4l-dev \
    libvorbis-dev \
    libx264-dev \
    libxine2-dev \
    libxvidcore-dev \
    pkg-config \
    protobuf-compiler \
    python3-dev \
    python3-pip \
    python3-numpy \
    python3-numpy-dev \
    python3-testresources \
    unzip \
    v4l-utils \
    x264 \
    yasm

    cd /usr/include/linux
    sudo ln -s -f ../libv4l1-videodev.h videodev.h
    
    ;;

  pdfjam-extras)

    # pdfjam command line support scripts such as pdfnup etc

    wget https://raw.githubusercontent.com/tobybreckon/pdfjam-extras/refs/heads/master/pdfjam-extras.spec
    VERSION=`cat pdfjam-extras.spec | grep Version | cut -d: -f2 | tr -d " "`
    wget https://github.com/tobybreckon/pdfjam-extras/releases/download/v$VERSION/pdfjam-extras-$VERSION-1_all.deb
    sudo apt install ./pdfjam-extras_$VERSION-1_all.deb

    ;;

  baseline)

   # everything else ....
   
   sudo apt install vlc exfat-fuse exfatprogs cmake-qt-gui v4l-utils v4l-conf nvtop htop nano git

   ##########
    ;;

  *)
    echo
    echo "Usage: ubuntu-package-install.sh [ repos | chrome | zoom | vscode | "
    echo "                                   edge | slack | ximea | cuda | f5vpn |"
    echo "                                   cudnn | opencv-extras | pdfjam-extras |"
    echo "                                   baseline | ... ]"
    echo
    echo "[ \"a quick hack\" by Toby Breckon, 2022+ ]"
    echo
    rm -rf $TMPDIR
    exit 1
    ;;
esac

################################################################################

rm -rf $TMPDIR

################################################################################
