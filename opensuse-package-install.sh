#!/bin/sh

################################################################################

# install a number of esoteric packages on OpenSuSE 15.x and later + Tumbleweed
# (semi-automatically without having to web search each set of commands)

# Toby Breckon, Durham University, May 2022

################################################################################

TMPDIR=$(mktemp -d)
cd $TMPDIR

################################################################################

case $1 in

  chrome)
    sudo zypper ar -f http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome
    wget https://dl.google.com/linux/linux_signing_key.pub
    sudo rpm --import linux_signing_key.pub
    sudo zypper refresh
    sudo zypper in google-chrome-stable
    ;;

  zoom)
    wget https://zoom.us/client/latest/zoom_openSUSE_x86_64.rpm
    wget -O package-signing-key.pub https://zoom.us/linux/download/pubkey
    sudo rpm --import package-signing-key.pub
    sudo zypper install zoom_openSUSE_x86_64.rpm
    ;;

  skype)
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper ar -f https://repo.skype.com/rpm/stable/skype-stable.repo
    sudo zypper --gpg-auto-import-keys refresh
    sudo zypper install skypeforlinux
    ;;

  teams)
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper ar -f https://packages.microsoft.com/yumrepos/ms-teams/ ms-teams
    sudo zypper refresh
    sudo zypper install teams
    ;;

  vscode)
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper ar -f https://packages.microsoft.com/yumrepos/vscode/ vscode
    sudo zypper refresh
    sudo zypper install code
    ;;

  edge)
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper ar -f https://packages.microsoft.com/yumrepos/edge/ edge
    sudo zypper refresh
    sudo zypper install microsoft-edge-stable
    ;;

  f5vpn)
    wget https://access.durham.ac.uk/public/download/linux_f5vpn.x86_64.rpm
    wget https://access.durham.ac.uk/public/download/linux_f5cli.x86_64.rpm
    sudo zypper install linux_f5vpn.x86_64.rpm linux_f5cli.x86_64.rpm
    ;;

  atom)
    sudo sh -c 'echo -e "[Atom]\nname=Atom Editor\nbaseurl=https://packagecloud.io/AtomEditor/atom/el/7/\$basearch\nenabled=1\ntype=rpm-md\ngpgcheck=0\nrepo_gpgcheck=1\ngpgkey=https://packagecloud.io/AtomEditor/atom/gpgkey" > /etc/zypp/repos.d/atom.repo'
    sudo zypper --gpg-auto-import-keys refresh
    sudo zypper install atom
    ;;

  dropbox)
    sudo zypper install libatomic1
    sudo zypper install dropbox
    dropbox start -i
    dropbox autostart y
    ;;

  ximea)
    wget https://www.ximea.com/downloads/recent/XIMEA_Linux_SP.tgz
    tar xzf XIMEA_Linux_SP.tgz
    cd package
    sudo ./install
    ;;

  brackets)
    flatpak install https://dl.flathub.org/repo/appstream/io.brackets.Brackets.flatpakref
    echo
    echo "Now run as: flatpak run io.brackets.Brackets"
    ;;

  cuda)
    sudo zypper ar -f https://developer.download.nvidia.com/compute/cuda/repos/opensuse15/x86_64/ "nVidia-Developer-Libraries"
    sudo zypper  --gpg-auto-import-keys refresh
    sudo zypper install cuda-11-3
    echo
    echo "CUDA version - 11.3 (latest for Pytorch as of 15/5/22)"
    echo
    ;;

  cudnn)
    wget https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/libcudnn8-8.2.1.32-1.cuda11.3.x86_64.rpm
    wget https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/libcudnn8-devel-8.2.1.32-1.cuda11.3.x86_64.rpm
    sudo zypper refresh
    sudo zypper install libcudnn*.rpm
    echo
    echo "cuDNN for CUDA 11.3 (latest for Pytorch as of 15/5/22)"
    echo
    ;;

  clamav)
    sudo zypper install clamav
    echo
    echo "Setting up freshcam timer via systemctl ..."
    echo
    sudo systemctl enable freshclam.timer
    echo
    echo "Checking freshcam status via systemctl ..."
    echo
    sudo systemctl status freshclam
    echo
    echo "Run scan as: sudo clamscan --max-filesize=4000M --max-scansize=4000M --recursive=yes --log=/tmp/clamav.log --infected /"
    echo
    ;;

  patterns)
    sudo zypper install -t pattern devel_basis devel_C_C++ devel_kernel multimedia
    ;;

  opencv-extras)
    sudo zypper install python-devel python38-numpy-devel tbb-devel libjpeg8-devel \
    libtiff-devel libjasper-devel libdc1394-devel \
    pkgconf-pkg-config libva-devel openblas-common-devel \
    atlascpp-devel lapack-devel eigen3-devel gstreamer-devel \
    libtesseract4 tesseract tesseract-ocr tesseract-ocr-devel \
    gflags gflags-devel gflags-devel-static glog-devel gdal-devel \
    gdcm-devel onnx-devel libxine-devel libceres-devel gstreamer*
    ;;

  baseline)
    sudo zypper install unison git lyx opera obs-v4l2sink nano kwrite \
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
    texlive-elsarticle pdftk
    ;;

  laptop-extras)
    sudo zypper install bluez-obexd obexd obexfs
    ;;

  *)
    echo
    echo "usage: suse_package_install [chrome | zoom | skype | teams | "
    echo "                             vscode | edge | f5vpn | atom  | "
    echo "                             dropbox | ximea | brackets | cuda |"
    echo "                             cudnn | clamav | patterns | "
    echo "                             opencv-extras | baseline | ... ]"
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
