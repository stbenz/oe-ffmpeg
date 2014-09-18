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

### Licensing issues

Although all sources compiled into the ffmpeg binaries are licensed under open
source licenses, the licenses may not be compatible. **Distributing the binaries
built from this repository may violate the GPL!**

### Building instructions

1. Get the OpenELEC sources (4.2 branch)  
`git clone -b openelec-4.2 https://github.com/OpenELEC/OpenELEC.tv.git &&
cd OpenELEC.tv`

2. Get the unofficial ffmpeg addon sources  
`git clone https://github.com/stbenz/oe-ffmpeg.git packages/unofficial/oe-ffmpeg`

3. Build OpenELEC release  
`PROJECT=Generic ARCH=x86_64 make release`

4. Build ffmpeg-programs addon  
`PROJECT=Generic ARCH=x86_64 ./scripts/create_addon ffmpeg-programs`
