#!/bin/sh

################################################################################

# install a number of esoteric packages on OpenSuSE 15.x and later using zypper
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
    sudo zypper ref -f
    sudo zypper in google-chrome-stable
    ;;

  zoom)
    wget https://zoom.us/client/latest/zoom_openSUSE_x86_64.rpm
    wget -O package-signing-key.pub https://zoom.us/linux/download/pubkey
    sudo rpm --import package-signing-key.pub
    sudo zypper install zoom_openSUSE_x86_64.rpm
    ;;

  skype)
    sudo zypper ar -f https://repo.skype.com/rpm/stable/skype-stable.repo
    sudo zypper refresh
    sudo zypper install skypeforlinux
    ;;

  teams)
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper ar -f https://packages.microsoft.com/yumrepos/ms-teams/ ms-teams
    sudo zypper refresh
    sudo zypper install teams
    ;;

  f5vpn)
    wget https://access.durham.ac.uk/public/download/linux_f5vpn.x86_64.rpm
    wget https://access.durham.ac.uk/public/download/linux_f5cli.x86_64.rpm
    sudo zypper install linux_f5vpn.x86_64.rpm linux_f5cli.x86_64.rpm
    echo
    echo *** for CLI VPN instructions - https://support.f5.com/csp/article/K47922841 ***
    echo
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
    echo "CUDA version - 11.3 (latest for Pytorch as of 15/5/22)"
    echo
    sudo zypper ar -f https://developer.download.nvidia.com/compute/cuda/repos/opensuse15/x86_64/ "nVidia-Developer-Libraries"
    sudo zypper refresh
    sudo zypper install cuda-11-3
    ;;

  cudnn)
    echo "cuDNN for CUDA 11.3 (latest for Pytorch as of 15/5/22)"
    echo
    wget https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/libcudnn8-8.2.1.32-1.cuda11.3.x86_64.rpm
    wget https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/libcudnn8-devel-8.2.1.32-1.cuda11.3.x86_64.rpm
    sudo zypper refresh
    sudo zypper install libcudnn*.rpm
    ;;

  patterns)
    sudo zypper in -t pattern devel_basis devel_C_C++ devel_kernel multimedia
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
    kdeconnect-kde xkill
    ;;

  *)
    echo
    echo "usage: suse_package_install [chrome | zoom | skype | teams | "
    echo "                            f5vpn | atom | dropbox | ximea | "
    echo "                            brackets | patterns | baseline | ... ]"
    echo
    echo "[ \"a quick hack\" by Toby Breckon, 2022+ ] "
    echo
    rm -rf $TMPDIR
    exit 1
    ;;
esac

################################################################################

rm -rf $TMPDIR

################################################################################
