#!/bin/sh

################################################################################

# install a number of esoteric packages on OpenSuSE 15.x and later using zypper
# (semi-automatically without having to web serach each set of commands)

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
    sudo zypper install -G linux_f5vpn.x86_64.rpm linux_f5cli.x86_64.rpm
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
    ;;

  baseline)
    sudo zypper install unison git lyx opera obs obs-v4l2sink nano kwrite \
    pavucontrol opera obs-studio-devel mtools mjpegtools zip youtube-dl \
    xterm xless vlc-noX vlc-codecs vlc-codec-gstreamer vlc v4l2loopback-utils \
    v4l-utils-lang v4l-utils v4l-tools v4l-conf unzip unrar powertop xcalc \
    wireless-tools wine-32bit wine whois which vtkdata vtk-examples vtk-devel \
    lame htop traceroute texmaker attica-qt5 MPlayer ImageMagick gzip gwenview5 \
    gv gparted gimp ghostscript-x11 ghostscript-fonts-std ghostscript-fonts-other \
    ghostscript gawk file fetchmsttfonts dos2unix diffutils cmake-gui cmake \
    bzip2 bind-utils nmap xournal klatexformula
    ;;

  *)
    echo
    echo "usage: suse_package_install [chrome | zoom | teams | f5vpn | atom | dropbox | baseline | ... ]"
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
