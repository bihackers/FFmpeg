#!/bin/bash

#FFMPEG_CFG_FLAGS="--disable-shared --enable-static --disable-ffserver --enable-cross-compile --enable-nonfree --disable-everything --enable-hwaccel=h264_videotoolbox --enable-videotoolbox --enable-gpl --enable-postproc --enable-network --enable-debug --disable-programs --disable-asm --enable-neon --enable-doc --enable-pic --enable-memalign-hack --enable-small --enable-encoder=aac --enable-decoder=pcm_mulaw --disable-demuxers --disable-parsers --disable-protocols --enable-demuxer=h264 --enable-demuxer=rtsp --enable-protocol=tcp --enable-protocol=udp --enable-protocol=hls --enable-protocol=rtmp --enable-protocol=http --enable-decoder=aac --enable-parser=aac --enable-parser=hevc --enable-decoder=hevc --enable-demuxer=hls --enable-demuxer=hevc --enable-parser=h264 --arch=i386 --target-os=darwin --prefix=ios_ffmpeg_build/i386 --assert-level=2"
FFMPEG_CFG_FLAGS="--disable-shared --enable-static --disable-ffserver --enable-cross-compile --enable-nonfree --disable-everything --enable-bsf=h264_mp4toannexb --disable-iconv --disable-videotoolbox --disable-audiotoolbox --enable-network --enable-debug --disable-programs --disable-asm --enable-neon --enable-doc --enable-pic --enable-memalign-hack --enable-small --enable-encoder=aac --enable-decoder=pcm_mulaw --disable-demuxers --disable-parsers --disable-protocols --enable-demuxer=h264 --enable-demuxer=rtsp --enable-protocol=tcp --enable-protocol=udp --enable-protocol=hls --enable-protocol=rtmp --enable-protocol=http --enable-decoder=aac --enable-parser=aac --enable-parser=hevc --enable-decoder=hevc --enable-demuxer=hls --enable-demuxer=hevc --enable-parser=h264 --arch=i386 --target-os=darwin --prefix=ios_ffmpeg_build/i386 --assert-level=2"
FF_XCRUN_CC="xcrun -sdk iphonesimulator clang"
FFMPEG_CFG_CPU=
FFMPEG_CFLAGS="-arch i386 -mios-simulator-version-min=6.0"
FFMPEG_LDFLAGS="-arch i386 -mios-simulator-version-min=6.0"
FFMPEG_DEP_LIBS=

mkdir -p ios_ffmpeg_build/i386

function build_one
{
./configure $FFMPEG_CFG_FLAGS \
        --cc="$FF_XCRUN_CC" \
        $FFMPEG_CFG_CPU \
        --extra-cflags="$FFMPEG_CFLAGS" \
        --extra-cxxflags="$FFMPEG_CFLAGS" \
        --extra-ldflags="$FFMPEG_LDFLAGS $FFMPEG_DEP_LIBS"
}

build_one
make clean
make -j3 
make install
cp config.h ./ios_ffmpeg_build/i386
