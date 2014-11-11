OpenELEC unofficial ffmpeg addon
================================

This is the unofficial ffmpeg addon repo for OpenELEC. It contains build files
to create an OpenELEC addon with the following ffmpeg binaries:
* ffmpeg
* ffprobe
* ffserver

Following external codecs are available in the binaries:
* fdk-aac
* lame
* libtheora
* libvorbis
* libvpx
* opus
* x264

### Building instructions

1. Get the OpenELEC sources (4.2 branch)  
`git clone -b openelec-4.2 https://github.com/OpenELEC/OpenELEC.tv.git &&
cd OpenELEC.tv`

2. Get the unofficial ffmpeg addon sources  
`git clone -b openelec-4.2 https://github.com/stbenz/oe-ffmpeg.git packages/unofficial/oe-ffmpeg`

3. Build OpenELEC release  
`PROJECT=Generic ARCH=x86_64 make release`

4. Build ffmpeg-programs addon  
`PROJECT=Generic ARCH=x86_64 ./scripts/create_addon ffmpeg-programs`

### Licensing issues

The license of fdk-aac is incompatible with the GPL. Distributing the addon with
included fdk-aac violates the GPL.

See https://github.com/FFmpeg/FFmpeg/blob/master/LICENSE.md#incompatible-libraries

To build a GPL conform addon without fdk-aac, build the addon like this:
`PROJECT=Generic ARCH=x86_64 FFMPEG_GPL=1 ./scripts/create_addon ffmpeg-programs`
