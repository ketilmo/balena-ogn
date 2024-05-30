#!/usr/bin/env bash
set -e

arch="$(dpkg --print-architecture)"
echo "System Architecture: $arch"

if [ "$arch" = "arm64" ]; then 
  url=http://download.glidernet.org/arm64/rtlsdr-ogn-bin-arm64-latest.tgz
elif [ "$arch" = "amd64" ]; then 
  url=http://download.glidernet.org/x64/rtlsdr-ogn-bin-x64-latest.tgz
elif [ "$arch" = "i386" ]; then 
  url=http://download.glidernet.org/x86/rtlsdr-ogn-bin-x86-latest.tgz
else
  url=http://download.glidernet.org/arm/rtlsdr-ogn-bin-ARM-latest.tgz
fi

wget --no-check-certificate -qO- $url | tar xvz
