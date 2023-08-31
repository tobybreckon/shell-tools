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

    sudo zypper ar -f https://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome
    wget https://dl.google.com/linux/linux_signing_key.pub
    sudo rpm --import linux_signing_key.pub
    # wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
    sudo zypper refresh
    # sudo zypper in google-chrome-stable_current_x86_64.rpm
    sudo zypper in google-chrome-stable
    ;;

  zoom)

    # zoom video conf

    wget https://zoom.us/client/latest/zoom_openSUSE_x86_64.rpm
    wget -O package-signing-key.pub https://zoom.us/linux/download/pubkey
    sudo rpm --import package-signing-key.pub
    sudo zypper install zoom_openSUSE_x86_64.rpm
    ;;

  skype)

    # MS Skype For Linux video conf

    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper ar -f https://repo.skype.com/rpm/stable/ skype
    sudo zypper --gpg-auto-import-keys refresh
    sudo zypper install skypeforlinux

    ;;

#  teams)

    # MS Teams video conf

 #   sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
 #   sudo zypper ar -f https://packages.microsoft.com/yumrepos/ms-teams/ ms-teams
 #   sudo zypper refresh
 #   sudo zypper install teams
 #   ;;

  vscode)

    # MS VS code editor

    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper ar -f https://packages.microsoft.com/yumrepos/vscode/ vscode
    sudo zypper refresh
    sudo zypper install code
    ;;

  edge)

    # MS edge browser

    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper ar -f https://packages.microsoft.com/yumrepos/edge/ edge
    sudo zypper refresh
    sudo zypper install microsoft-edge-stable
    ;;

  f5vpn)

    # f5 networks VPN solution - GUI + CLI

    wget https://access.durham.ac.uk/public/download/linux_f5vpn.x86_64.rpm
    wget https://access.durham.ac.uk/public/download/linux_f5cli.x86_64.rpm
    sudo zypper install linux_f5vpn.x86_64.rpm linux_f5cli.x86_64.rpm
    ;;

  # atom)

    # atom editor

  #  sudo sh -c 'echo -e "[Atom]\nname=Atom Editor\nbaseurl=https://packagecloud.io/AtomEditor/atom/el/7/\$basearch\nenabled=1\ntype=rpm-md\ngpgcheck=0\nrepo_gpgcheck=1\ngpgkey=https://packagecloud.io/AtomEditor/atom/gpgkey" > /etc/zypp/repos.d/atom.repo'
  #  sudo zypper --gpg-auto-import-keys refresh
  #  sudo zypper install atom
  #  ;;

  dropbox)

    # install + setup dropbox

    sudo zypper install libatomic1
    sudo zypper install dropbox
    dropbox start -i
    dropbox autostart y
    ;;

  ximea)

    # ximea camera drivers - for OpenCV build

    wget https://www.ximea.com/downloads/recent/XIMEA_Linux_SP.tgz
    tar xzf XIMEA_Linux_SP.tgz
    cd package
    sudo rm -rf /opt/XIMEA
    sudo ./install
    sudo ln -sf /usr/lib64/libtiff.so.6 /usr/lib64/libtiff.so.5
    ;;

  brackets)

    # brackets editor

    flatpak install https://dl.flathub.org/repo/appstream/io.brackets.Brackets.flatpakref
    echo
    echo "Now run as: flatpak run io.brackets.Brackets"
    ;;

  cuda)

    # nvidia cuda - full stack

    sudo zypper ar -f https://developer.download.nvidia.com/compute/cuda/repos/opensuse15/x86_64/ "nVidia-Developer-Libraries"
    sudo zypper  --gpg-auto-import-keys refresh
    sudo zypper install cuda-11-8
    echo
    echo "CUDA version - 11.8 (latest for Pytorch as of 17/1/23)"
    echo
    ;;

  cudnn)

    # nvidia cuCNN deep learning base library

    wget https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/libcudnn8-8.7.0.84-1.cuda11.8.x86_64.rpm
    wget https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/libcudnn8-devel-8.7.0.84-1.cuda11.8.x86_64.rpm
    sudo zypper refresh
    sudo zypper install libcudnn*.rpm
    echo
    echo "cuDNN for CUDA 11.8 (latest for Pytorch as of 17/1/23)"
    echo
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

    # extensions one-size, ISO signage, multisave, expand animations

    wget https://extensions.libreoffice.org/assets/downloads/z/kvd-0-3-7.oxt
    sudo /usr/lib64/libreoffice/program/unopkg add -v --shared kvd-0-3-7.oxt
    wget https://extensions.libreoffice.org/assets/downloads/1778/1637949852/GallerySignauxDangers.3.1.0.oxt
    sudo /usr/lib64/libreoffice/program/unopkg add -v --shared GallerySignauxDangers.3.1.0.oxt
    wget https://extensions.libreoffice.org/assets/downloads/z/multiformatsave-v1-5-6.oxt
    sudo /usr/lib64/libreoffice/program/unopkg add -v --shared multiformatsave-v1-5-6.oxt
    wget https://github.com/monperrus/ExpandAnimations/releases/download/0.13/ExpandAnimations-0.13.oxt
    sudo /usr/lib64/libreoffice/program/unopkg add -v --shared ExpandAnimations-0.13.oxt
    ;;

  pdfjam-extras)

    # pdfjam command line support scripts such as pdfnup etc

    wget https://github.com/tobybreckon/pdfjam-extras/releases/download/v0.11/pdfjam-extras-0.11-0.noarch.rpm
    wget -O package-signing-key.pub https://breckon.org/toby/pgp.txt
    sudo rpm --import package-signing-key.pub
    sudo rpm -i pdfjam-extras-0.11-0.noarch.rpm

    ;;

  patterns)

    # base SuSE software patterns

    sudo zypper install -t pattern devel_basis devel_C_C++ devel_kernel multimedia
    ;;

  opencv-extras)

    # additional packages required for fully functional OpenCV build from source

    sudo zypper install python-devel python311-numpy-devel tbb-devel libjpeg8-devel \
    libtiff-devel libjasper-devel libdc1394-devel \
    pkgconf-pkg-config libva-devel openblas-common-devel \
    atlascpp-devel lapack-devel eigen3-devel gstreamer-devel \
    libtesseract* tesseract tesseract-ocr tesseract-ocr-devel \
    gflags gflags-devel gflags-devel-static glog-devel gdal-devel \
    gdcm-devel onnx-devel libxine-devel libceres-devel glibc-devel-32bit \
    librealsense librealsense-devel libgphoto2-devel aravis libaravis-0_8-0 libaravis-0_8-devel \
    libmfx* gstreamer* gcc7 gcc7-c++
    ;;

  baseline)

   # everything else ....

    sudo zypper install unison git lyx opera nano kwrite \
    pavucontrol opera obs-studio-devel mtools mjpegtools zip youtube-dl \
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
    v4l2loopback-kmp-default 
    ;;

  packaging)

   # tools for building rpm and deb packages

    sudo zypper install rpmdevtools rpmlint dpkg
    ;;

  laptop-extras)

    # everything laptop specific ....

    sudo zypper install bluez-obexd obexd obexfs
    ;;

  *)
    echo
    echo "Usage: opensuse-package-install.sh [chrome | zoom | skype | vscode |"
    echo "                                    edge | f5vpn | dropbox | ximea |"
    echo "                                    brackets | cuda | cudnn | clamav |"
    echo "                                    pdfjam-extras | patterns |"
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
