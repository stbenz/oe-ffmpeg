OpenELEC unofficial ffmpeg and tvheadend addons
===============================================

This repository contains build files to create an OpenELEC addon 
"ffmpeg-programs" with the following ffmpeg binaries:
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

It also contains build files to create the OpenELEC addon "tvheadend" with
transcoding support.

### Building instructions

```
# Get the OpenELEC sources (5.0 branch)  
git clone -b openelec-5.0 https://github.com/OpenELEC/OpenELEC.tv.git && cd OpenELEC.tv

# Get the unofficial ffmpeg addon sources  
git clone https://github.com/stbenz/oe-ffmpeg.git packages/oe-ffmpeg

# Build OpenELEC release  
PROJECT=Generic ARCH=x86_64 make release

# Build ffmpeg-programs addon  
PROJECT=Generic ARCH=x86_64 ./scripts/create_addon ffmpeg-programs

# Build tvheadend addon  
PROJECT=Generic ARCH=x86_64 ./scripts/create_addon tvheadend
```

### Licensing issues

The license of fdk-aac is incompatible with the GPL. Distributing the addons 
with included fdk-aac violates the GPL.

See https://github.com/FFmpeg/FFmpeg/blob/master/LICENSE.md#incompatible-libraries

To build a GPL conform addons without fdk-aac, build the addons like this:
``` 
# ffmpeg-programs
PROJECT=Generic ARCH=x86_64 FFMPEG_GPL=1 ./scripts/create_addon ffmpeg-programs

# tvheadend
PROJECT=Generic ARCH=x86_64 FFMPEG_GPL=1 ./scripts/create_addon tvheadend
```
