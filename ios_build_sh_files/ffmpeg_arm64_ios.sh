#!/bin/bash

#FFMPEG_CFG_FLAGS="--disable-shared --enable-static --disable-ffserver --enable-cross-compile --enable-nonfree --disable-everything --enable-hwaccel=h264_videotoolbox --enable-videotoolbox --enable-gpl --enable-postproc --enable-network --enable-debug --disable-programs --disable-asm --enable-neon --enable-doc --enable-pic --enable-memalign-hack --enable-small --enable-encoder=aac --enable-decoder=pcm_mulaw --disable-demuxers --disable-parsers --disable-protocols --enable-demuxer=h264 --enable-demuxer=rtsp --enable-protocol=tcp --enable-protocol=udp --enable-protocol=hls --enable-protocol=rtmp --enable-protocol=http --enable-decoder=aac --enable-parser=aac --enable-parser=hevc --enable-decoder=hevc --enable-demuxer=hls --enable-demuxer=hevc --enable-parser=h264 --arch=arm64 --target-os=darwin --prefix=ios_ffmpeg_build/arm64"
FFMPEG_CFG_FLAGS="--disable-shared --enable-static --disable-ffserver --enable-cross-compile --enable-nonfree --disable-everything --enable-bsf=h264_mp4toannexb --disable-videotoolbox --disable-audiotoolbox --disable-iconv --enable-network --enable-debug --disable-programs --disable-asm --enable-neon --enable-doc --enable-pic --enable-memalign-hack --enable-small --enable-encoder=aac --enable-decoder=pcm_mulaw --disable-demuxers --disable-parsers --disable-protocols --enable-demuxer=h264 --enable-demuxer=rtsp --enable-protocol=tcp --enable-protocol=udp --enable-protocol=hls --enable-protocol=rtmp --enable-protocol=http --enable-decoder=aac --enable-parser=aac --enable-parser=hevc --enable-decoder=hevc --enable-demuxer=hls --enable-demuxer=hevc --enable-parser=h264 --arch=arm64 --target-os=darwin --prefix=ios_ffmpeg_build/arm64"
FF_XCRUN_CC="xcrun -sdk iphoneos clang"
FFMPEG_CFG_CPU=
FFMPEG_CFLAGS="-arch arm64 -miphoneos-version-min=7.0  -fembed-bitcode"
FFMPEG_LDFLAGS="-arch arm64 -miphoneos-version-min=7.0  -fembed-bitcode"
FFMPEG_DEP_LIBS=

mkdir -p ios_ffmpeg_build/arm64

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
make -j3 "GASPP_FIX_XCODE5=1"
make install
cp config.h ./ios_ffmpeg_build/arm64