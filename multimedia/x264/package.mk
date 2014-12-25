################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2014 Stefan Benz (benz.st@gmail.com)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="x264"
PKG_VERSION="snapshot-20141218-2245-stable"
PKG_REV="333"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://videolan.org"
PKG_URL="ftp://ftp.videolan.org/pub/videolan/x264/snapshots/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain yasm:host"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="x264 is a free software library and application for encoding video streams into the H.264/MPEG-4 AVC compression format."
PKG_LONGDESC="x264 is a free software library and application for encoding video streams into the H.264/MPEG-4 AVC compression format."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

if [ "$DEBUG" = yes ]; then
  X264_DEBUG="--enable-debug"
else
  X264_DEBUG="--enable-strip"
fi

case "$TARGET_ARCH" in
  arm)
      X264_PIC="--enable-pic"
  ;;
  i?86)
      X264_PIC="--disable-pic"
  ;;
  x86_64)
      X264_PIC="--enable-pic"
  ;;
esac

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_configure_target() {
# x264 fails building with LTO support
  strip_lto

# x264 fails running with GOLD support
  strip_gold
}

configure_target() {
  ./configure --prefix=/usr \
              --host=$TARGET_NAME \
              --cross-prefix=$TARGET_PREFIX \
              --sysroot=$SYSROOT_PREFIX \
              --extra-cflags="$CFLAGS" \
              --extra-ldflags="$LDFLAGS" \
              --enable-static \
              $X264_DEBUG \
              $X264_PIC \
              --disable-opencl \
              --disable-avs \
              --disable-cli \
              --disable-ffms \
              --disable-gpac \
              --disable-lavf \
              --disable-swscale
}
