#!/usr/bin/env bash
set -e

arch="$(dpkg --print-architecture)"
echo System Architecture: $arch

cd /tmp/

if [ "$arch" = "arm64" ]; then 
  tar xvf rtlsdr-ogn-bin-arm64-0.2.9_debian_bullseye.tgz
elif [ "$arch" = "amd64" ]; then 
  tar xvf rtlsdr-ogn-bin-x64-0.2.9_debian_bullseye.tgz
elif [ "$arch" = "i386" ]; then 
  tar xvf rtlsdr-ogn-bin-x86-0.2.9_debian_buster.tgz
else 
  tar xvf rtlsdr-ogn-bin-ARM-0.2.9_raspbian_buster.tgz
fi
