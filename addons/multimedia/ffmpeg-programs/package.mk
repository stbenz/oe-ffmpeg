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

PKG_NAME="ffmpeg-programs"
PKG_VERSION="2.4.3"
PKG_REV="3"
PKG_ARCH="any"
PKG_LICENSE="nonfree"
PKG_SITE="http://ffmpeg.org"
PKG_URL="http://ffmpeg.org/releases/ffmpeg-${PKG_VERSION}.tar.bz2"
PKG_SOURCE_DIR="ffmpeg-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain yasm:host zlib bzip2 libvorbis libtheora gnutls x264 lame libvpx opus"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video."
PKG_LONGDESC="FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. The programs contain the following external codecs: libtheora, libvorbis, opus, x264, libvpx, lame and fdk-aac."
PKG_DISCLAIMER="WARNING: This addon contains code under licenses that are not compatible to the GPL. Distributing this addon in binary form violates the terms of the GPL!"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"

PKG_AUTORECONF="no"

if [ -z "$FFMPEG_GPL" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET fdk-aac"
  FFMPEG_FDKAAC="--enable-nonfree --enable-libfdk-aac"
else
  PKG_LICENSE="GPL"
  FFMPEG_FDKAAC="--disable-libfdk-aac"
fi

if [ "$VAAPI" = yes ]; then
# configure GPU drivers and dependencies:
  get_graphicdrivers

  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libva-intel-driver"
  FFMPEG_VAAPI="--enable-vaapi"
else
  FFMPEG_VAAPI="--disable-vaapi"
fi

if [ "$VDPAU" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libvdpau"
  FFMPEG_VDPAU="--enable-vdpau"
else
  FFMPEG_VDPAU="--disable-vdpau"
fi

if [ "$DEBUG" = yes ]; then
  FFMPEG_DEBUG="--enable-debug --disable-stripping"
else
  FFMPEG_DEBUG="--disable-debug --enable-stripping"
fi

if [ "$OPTIMIZATIONS" = size ]; then
  FFMPEG_OPTIM="--disable-small"
else
  FFMPEG_OPTIM="--disable-small"
fi

case "$TARGET_ARCH" in
  arm)
      FFMPEG_CPU=""
      FFMPEG_TABLES="--enable-hardcoded-tables"
      FFMPEG_PIC="--enable-pic"
  ;;
  i?86)
      FFMPEG_CPU=""
      FFMPEG_TABLES="--disable-hardcoded-tables"
      FFMPEG_PIC="--disable-pic"
  ;;
  x86_64)
      FFMPEG_CPU=""
      FFMPEG_TABLES="--disable-hardcoded-tables"
      FFMPEG_PIC="--enable-pic"
  ;;
esac

case "$TARGET_FPU" in
  neon*)
      FFMPEG_FPU="--enable-neon"
  ;;
  vfp*)
      FFMPEG_FPU=""
  ;;
  *)
      FFMPEG_FPU=""
  ;;
esac

unpack() {
  tar xjf  "$SOURCES/$PKG_NAME/ffmpeg-${PKG_VERSION}.tar.bz2" -C $BUILD
}

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME

  export pkg_config="$ROOT/$TOOLCHAIN/bin/pkg-config"

# ffmpeg fails building with LTO support
  strip_lto

# ffmpeg fails running with GOLD support
  strip_gold
}

configure_target() {
  ./configure --prefix=/usr \
              --cpu=$TARGET_CPU \
              --arch=$TARGET_ARCH \
              --enable-cross-compile \
              --cross-prefix=$TARGET_PREFIX \
              --sysroot=$SYSROOT_PREFIX \
              --sysinclude="$SYSROOT_PREFIX/usr/include" \
              --target-os="linux" \
              --nm="$NM" \
              --ar="$AR" \
              --as="$CC" \
              --cc="$CC" \
              --ld="$CC" \
              --host-cc="$HOST_CC" \
              --host-cflags="$HOST_CFLAGS" \
              --host-ldflags="$HOST_LDFLAGS" \
              --host-libs="-lm" \
              --extra-cflags="$CFLAGS" \
              --extra-ldflags="$LDFLAGS" \
              --extra-libs="" \
              --extra-version="" \
              --build-suffix="" \
              --enable-static \
              --disable-shared \
              --enable-gpl \
              --disable-doc \
              $FFMPEG_DEBUG \
              $FFMPEG_PIC \
              --enable-optimizations \
              --disable-armv5te \
              --disable-armv6t2 \
              --disable-extra-warnings \
              $FFMPEG_OPTIM \
              $FFMPEG_VAAPI \
              $FFMPEG_VDPAU \
              --disable-crystalhd \
              --disable-dxva2 \
              --enable-runtime-cpudetect \
              $FFMPEG_TABLES \
              --enable-gnutls \
              --enable-avresample \
              --disable-libressl \
              $FFMPEG_FDKAAC \
              --enable-libmp3lame \
              --enable-libopus \
              --enable-libvorbis \
              --enable-libvpx \
              --enable-libx264 \
              --enable-libtheora \
              $FFMPEG_CPU \
              $FFMPEG_FPU \
              --enable-yasm
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/ffmpeg/examples
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.install_pkg/usr/bin/ffmpeg $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.install_pkg/usr/bin/ffserver $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.install_pkg/usr/bin/ffprobe $ADDON_BUILD/$PKG_ADDON_ID/bin
}
