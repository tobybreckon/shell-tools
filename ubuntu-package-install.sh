#!/bin/sh

################################################################################

# install a number of esoteric packages on Ubuntu 22.04 and later
# (semi-automatically without having to web search each set of commands)

# Toby Breckon, Durham University, August 2022

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

    sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ./google-chrome-stable_current_amd64.deb
    ;;

  zoom)

    # zoom video conf

    wget https://zoom.us/client/latest/zoom_amd64.deb
    sudo apt install ./zoom_amd64.deb
    ;;

  skype)

    # MS Skype For Linux video conf

    wget https://go.skype.com/skypeforlinux-64.deb
    sudo apt install ./skypeforlinux-64.deb
    ;;

  teams)

    # MS Teams video conf

    wget https://packages.microsoft.com/keys/microsoft.asc
    sudo apt-key add microsoft.asc
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
    sudo apt update
    sudo apt install teams
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

    sudo apt-key add microsoft.asc
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/edge.list'
    sudo apt update
    sudo apt install microsoft-edge-stable
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

    sudo apt install nvidia-cuda-toolkit nvidia-cuda-toolkit
    ;;

  cudnn)

    # nvidia cuCNN deep learning base library

    sudo apt install nvidia-cudnn
  
    ;;

  opencv-extras)

    # additional packages required for fully functional OpenCV build from source

    sudo apt update
    sudo apt upgrade
    sudo apt install build-essential cmake pkg-config unzip yasm git checkinstall
    sudo apt install libjpeg-dev libpng-dev libtiff-dev
    sudo apt install libavcodec-dev libavformat-dev libswscale-dev libavresample-dev
    sudo apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
    sudo apt install libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev 
    sudo apt install libfaac-dev libmp3lame-dev libvorbis-dev
    sudo apt install libavcodec-dev libavformat-dev libswscale-dev libavresample-dev
    sudo apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
    sudo apt install libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev 	 
    sudo apt install libfaac-dev libmp3lame-dev libvorbis-dev
    
    sudo apt-get install libdc1394-22 libdc1394-22-dev libxine2-dev libv4l-dev v4l-utils
    cd /usr/include/linux
    sudo ln -s -f ../libv4l1-videodev.h videodev.h
    cd ~
    
    sudo apt-get install libgtk-3-dev
    sudo apt-get install python3-dev python3-pip
    sudo -H pip3 install -U pip numpy
    sudo apt install python3-testresources
    sudo apt-get install libtbb-dev
    sudo apt-get install libatlas-base-dev gfortran
    sudo apt-get install libprotobuf-dev protobuf-compiler
    sudo apt-get install libgoogle-glog-dev libgflags-dev
    sudo apt-get install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen

    ;;

  baseline)

   # everything else ....
   
   sudo apt install vlc cvlc

   ##########
    ;;

  *)
    echo
    echo "usage: ubuntu-package-install [repos | chrome | zoom | skype | teams | "
    echo "                               vscode | edge | ximea | cuda |"
    echo "                               cudnn | opencv-extras | baseline | ... ]"
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