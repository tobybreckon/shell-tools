#!/bin/sh

################################################################################

# install a number of esoteric packages on OpenSuSE 15.x and later + Tumbleweed
# (semi-automatically without having to web search each set of commands)

# Toby Breckon, Durham University, May 2022

################################################################################

TMPDIR=$(mktemp -d)
cd $TMPDIR

################################################################################

set -e

################################################################################

case $1 in

  chrome)

    # google chrome browser

    sudo zypper ar -f -n "Google Chrome Browser" https://dl.google.com/linux/chrome/rpm/stable/x86_64 google-chrome
    wget https://dl.google.com/linux/linux_signing_key.pub
    sudo rpm --import linux_signing_key.pub
    sudo zypper refresh
    sudo zypper in google-chrome-stable
    ;;

  zoom)

    # zoom video conf

    wget https://zoom.us/client/latest/zoom_openSUSE_x86_64.rpm
    wget -O package-signing-key.pub https://zoom.us/linux/download/pubkey?version=5-12-6
    sudo rpm --import package-signing-key.pub
    sudo zypper install zoom_openSUSE_x86_64.rpm
    ;;

  vscode)

    # MS VS code editor

    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper ar -f -n "MS Visual Studio Code" https://packages.microsoft.com/yumrepos/vscode/ ms-vscode
    sudo zypper refresh
    sudo zypper install code
    ;;

  edge)

    # MS edge browser

    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper ar -f -n "MS Edge Browser" https://packages.microsoft.com/yumrepos/edge/ ms-edge
    sudo zypper refresh
    sudo zypper install microsoft-edge-stable
    ;;

  .net)

    # MS .NET runtime v 8.x for linux
    
    sudo zypper install libicu
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    wget https://packages.microsoft.com/config/opensuse/15/prod.repo
    sudo mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
    sudo chown root:root /etc/zypp/repos.d/microsoft-prod.repo

    # runtime only

    sudo zypper install dotnet-runtime-8.0

    # runtime with asp

    # sudo zypper install aspnetcore-runtime-8.0

    # sdk 

    # sudo zypper install dotnet-sdk-8.0

    ;;

  f5vpn)

    # f5 networks VPN solution - GUI + CLI

    wget https://access.durham.ac.uk/public/download/linux_f5vpn.x86_64.rpm
    wget https://access.durham.ac.uk/public/download/linux_f5cli.x86_64.rpm
    sudo zypper remove f5vpn f5cli # delete first otherwise install fails (as dir below is deleted but still assumed present)
    sudo mkdir -p /opt/f5/vpn/ # following install can break if this directory is not present
    sudo zypper install libcap-progs # unrecorded dependancy of f5 vpn install 
    sudo zypper install linux_f5vpn.x86_64.rpm linux_f5cli.x86_64.rpm
    ;;

  dropbox)

    # install + setup dropbox

    sudo zypper install libatomic1
    sudo zypper install dropbox
    dropbox start -i
    dropbox autostart y
    ;;

  slack)

    # install slack

    wget https://slack.com/gpg/slack_pubkey_20240822.gpg
    sudo rpm --import slack_pubkey_20240822.gpg

    wget -q https://slack.com/intl/en-gb/downloads/instructions/linux?build=rpm -O - \
    | tr "\t\r\n'" '   "' \
    | grep -i -o '<a[^>]\+href[ ]*=[ \t]*"\(ht\|f\)tps\?:[^"]\+"' \
    | sed -e 's/^.*"\([^"]\+\)".*$/\1/g' \
    | grep 'slack.*64.rpm' \
    | head -1 \
    | xargs wget -q -O slack-desktop-latest.rpm 
    sudo zypper in slack-desktop-latest.rpm 
    ;;

  ximea)

    # ximea camera drivers - for OpenCV build

    wget https://www.ximea.com/downloads/recent/XIMEA_Linux_SP.tgz
    tar xzf XIMEA_Linux_SP.tgz
    cd package
    sudo ./install
    ;;

  brackets)

    # brackets editor

    flatpak install https://dl.flathub.org/repo/appstream/io.brackets.Brackets.flatpakref
    echo
    echo "Now run as: flatpak run io.brackets.Brackets"
    ;;

  cuda)

    # nvidia cuda - full stack

    sudo zypper ar -f -n "NVidia Developer Libraries" https://developer.download.nvidia.com/compute/cuda/repos/opensuse15/x86_64/ "nvidia-developer-libraries"
    sudo zypper  --gpg-auto-import-keys refresh
    sudo zypper install cuda-12-8
    echo
    echo "CUDA version - 12-8"
    echo
    ;;

  pheonix)

    # pheonix editor (installed local to current user)
    
    echo
    wget -qO- https://updates.phcode.io/linux/installer.sh | bash
    echo
    ;;

  cudnn)

    # nvidia cuCNN deep learning base library

    sudo zypper refresh
    sudo zypper install libcudnn9-cuda-12 libcudnn9-devel-cuda-12 libcudnn9-static-cuda-12
    echo
    ;;

  nvcuvid)

    # nvidia Video Codec Interface SDK - N.B. download requires login to Nvidia Developer site

    echo "Manually download: https://developer.nvidia.com/downloads/designworks/video-codec-sdk/secure/12.1/video_codec_sdk_12.1.14.zip"
    echo "Save into directory to ... : " $PWD
    echo "then press enter."
    read
    unzip *zip 
    mkdir -p  /usr/local/cuda/include/
    cd Video_Codec_SDK_*/Interface/
    sudo cp  *.h /usr/local/cuda/include/
    cd ../Lib/linux/stubs/x86_64
    sudo cp *.so /usr/lib64/
    sudo ldconfig -i
  ;;

  zed)

    # ZED stereo camera sdk

    wget -O zed-installer.run https://download.stereolabs.com/zedsdk/4.0/cu118/ubuntu22
    chmod +x zed-installer.run
    sudo ln -s /opt/zed /usr/local/zed
    ./zed-installer.run
    ;;

  clamav)

    # clam anti-virus

    sudo zypper install clamav

    sudo systemctl start freshclam 
    echo "Checking freshcam status via systemctl ..."
    echo
    sudo systemctl status freshclam
    echo
    echo "Setting up freshcam timer via systemctl ..."
    echo
    sudo systemctl enable freshclam.timer
    echo
    echo
    echo "Run scan as: sudo clamscan --max-filesize=4000M --max-scansize=4000M --recursive=yes --log=/tmp/clamav.log --infected /"
    echo
    ;;

  libreoffice-extensions)

    # extensions one-size, ISO signage, multisave, expand animations, mathtex

    wget https://extensions.libreoffice.org/assets/downloads/z/kvd-0-3-7.oxt
    sudo /usr/lib64/libreoffice/program/unopkg add -v --shared kvd-0-3-7.oxt
    wget https://extensions.libreoffice.org/assets/downloads/1778/1637949852/GallerySignauxDangers.3.1.0.oxt
    sudo /usr/lib64/libreoffice/program/unopkg add -v --shared GallerySignauxDangers.3.1.0.oxt
    wget https://extensions.libreoffice.org/assets/downloads/z/multiformatsave-v1-5-6.oxt
    sudo /usr/lib64/libreoffice/program/unopkg add -v --shared multiformatsave-v1-5-6.oxt
    wget https://github.com/monperrus/ExpandAnimations/releases/download/0.13/ExpandAnimations-0.13.oxt
    sudo /usr/lib64/libreoffice/program/unopkg add -v --shared ExpandAnimations-0.13.oxt
    wget https://extensions.libreoffice.org/assets/downloads/1236/1729932096/TexMaths-0.52.3.oxt
    sudo /usr/lib64/libreoffice/program/unopkg add -v --shared TexMaths-0.52.3.oxt
    ;;

  pdfjam-extras)

    # pdfjam command line support scripts such as pdfnup etc

    wget https://raw.githubusercontent.com/tobybreckon/pdfjam-extras/refs/heads/master/pdfjam-extras.spec
    VERSION=`cat pdfjam-extras.spec | grep Version | cut -d: -f2 | tr -d " "`
    wget https://github.com/tobybreckon/pdfjam-extras/releases/download/v$VERSION/pdfjam-extras-$VERSION-0.noarch.rpm
    wget -O package-signing-key.pub https://breckon.org/toby/pgp.txt
    sudo rpm --import package-signing-key.pub
    sudo rpm -Ui pdfjam-extras-$VERSION-0.noarch.rpm

    ;;

  patterns)

    # base SuSE software patterns

    sudo zypper install -t pattern devel_basis devel_C_C++ devel_kernel multimedia
    ;;

  realsense)

    # intel realsense drivers, library and viewer

    sudo zypper install librealsense
    ;;

  opencv-extras)

    # additional packages required for fully functional OpenCV build from source

    sudo zypper install python-devel python-numpy-devel tbb-devel libjpeg8-devel \
    libtiff-devel libjasper-devel libdc1394-devel \
    pkgconf-pkg-config libva-devel openblas-common-devel \
    atlascpp-devel lapack-devel eigen3-devel gstreamer-devel \
    libtesseract4 tesseract tesseract-ocr tesseract-ocr-devel \
    gflags gflags-devel gflags-devel-static glog-devel gdal-devel \
    gdcm-devel onnx-devel libxine-devel libceres-devel glibc-devel-32bit \
    libgphoto2-devel libaravis-*-devel opencl-cpp-headers opencl-headers gstreamer* \
    coin-or-Clp coin-or-Clp-devel ffmpeg-7-mini-devel
    ;;

  baseline)

   # everything else ....

    sudo zypper install unison git lyx opera nano kwrite \
    pavucontrol opera obs-studio-devel mtools mjpegtools zip yt-dlp yt-dlp-youtube-dl \
    xterm xless vlc-noX vlc-codecs vlc-codec-gstreamer vlc v4l2loopback-utils \
    v4l-utils-lang v4l-utils v4l-tools v4l-conf unzip unrar powertop xcalc \
    wireless-tools wine-32bit wine whois which vtkdata vtk-devel \
    lame htop traceroute texmaker attica-qt5 MPlayer ImageMagick gzip gwenview5 \
    gv gparted gimp ghostscript-x11 ghostscript-fonts-std ghostscript-fonts-other \
    ghostscript gawk file fetchmsttfonts dos2unix diffutils cmake-gui cmake \
    bzip2 bind-utils nmap xournalpp klatexformula kernel-devel openvpn mlocate \
    kdeconnect-kde xkill xev texlive-spie texlive-ieeeconf texlive-ieeetran \
    texlive-biblatex-ieee texlive-llncs texlive-biblatex-lncs texlive-llncsconf \
    texlive-elsarticle pdftk sox arping2 arpwatch nvtop simplescreenrecorder \
    v4l2loopback-kmp-default heif-examples mpv
    ;;

  packaging)

   # tools for building rpm and deb packages

    sudo zypper install rpmdevtools rpmlint dpkg
    ;;

  laptop-extras)

    # everything laptop specific ....

    sudo zypper install bluez-obexd obexd obexfs wireguard-tools solaar
    ;;

  *)
    echo
    echo "Usage: opensuse-package-install.sh [chrome | zoom | vscode | edge | .net"
    echo "                                    f5vpn | dropbox | slack | ximea |"
    echo "                                    brackets | cuda | cudnn | nvcuvid |"
    echo "                                    zed | clamav | pdfjam-extras |"
    echo "                                    patterns | realsense | pheonix"
    echo "                                    libreoffice-extensions | laptop-extras |"
    echo "                                    packaging | opencv-extras | baseline | ... ]"
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
