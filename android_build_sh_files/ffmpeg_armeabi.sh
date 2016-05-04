#!/bin/bash
NDK=$ANDROID_NDK 
SYSROOT=$NDK/platforms/android-9/arch-arm/
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
mkdir -p ./tmp
export TMPDIR=./tmp
OLD=""
ADDI_CFLAGS=
#ADDITIONAL_CONFIGURE_FLAG="--disable-everything --enable-cross-compile --enable-debug --disable-programs \
#                 --enable-asm --enable-neon --enable-doc --enable-pic --enable-memalign-hack --enable-small \
#                 --enable-decoder=h264  --enable-encoder=aac --enable-decoder=pcm_mulaw  --disable-demuxers --disable-parsers --disable-protocols  \
#                 "
export CC="$TOOLCHAIN/bin/arm-linux-androideabi-gcc"
export LD=$TOOLCHAIN/bin/arm-linux-androideabi-ld
export AR=$TOOLCHAIN/bin/arm-linux-androideabi-ar
export STRIP=$TOOLCHAIN/bin/arm-linux-androideabi-strip
function build_one
{
./configure \
--prefix=$PREFIX \
--disable-shared \
--enable-static \
--enable-ffserver \
--enable-cross-compile \
--cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
--target-os=linux \
--arch=arm \
--sysroot=$SYSROOT \
--extra-cflags="-Os -fpic $ADDI_CFLAGS -mfpu=neon -mfloat-abi=softfp" \
--extra-ldflags="$ADDI_LDFLAGS" \
--enable-nonfree \
--disable-everything \
--enable-gpl \
--enable-postproc \
--enable-debug \
--disable-programs \
--disable-asm \
--enable-neon \
--enable-doc \
--enable-pic \
--enable-memalign-hack \
--enable-small \
--enable-decoder=h264 \
--enable-encoder=aac \
--enable-decoder=pcm_mulaw \
--disable-demuxers \
--disable-parsers \
--disable-protocols \
--enable-demuxer=h264 \
--enable-demuxer=rtsp \
--enable-protocol=tcp \
--enable-protocol=udp \
--enable-protocol=hls \
--enable-protocol=rtmp \
--enable-protocol=http \
--enable-decoder=aac \
--enable-parser=aac \
--enable-parser=hevc \
--enable-decoder=hevc \
--enable-demuxer=hls \
--enable-demuxer=hevc \
--enable-parser=h264 \
--enable-network
#--enable-mediacodec \
#--enable-jni \
#--enable-decoder=h264_mediacodec
}
CPU=arm
PREFIX=android_ffmpeg_build/armeabi
mkdir -p $PREFIX
ADDI_LDFLAGS=
ADDI_CFLAGS="-marm -O3 -Wall -mthumb -pipe -fpic -fasm \
  -finline-limit=300 -ffast-math \
  -fstrict-aliasing -Werror=strict-aliasing \
  -fmodulo-sched -fmodulo-sched-allow-regmoves \
  -Wno-psabi -Wa,--noexecstack \
  -D__ARM_ARCH_5__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5TE__ \
  -DANDROID -DNDEBUG"
build_one
make clean
make -j4 || exit 1
make install || exit 1
cp config.h ./android_ffmpeg_build/armeabi
  #rm libavcodec/inverse.o
  #rm libavcodec/log2_tab.o
 # rm libavutil/log2_tab.o
 # rm libswresample/log2_tab.o
 # rm libswscale/log2_tab.o
 # rm libavformat/golomb_tab.o
 # rm libavcodec/reverse.o
#export CC="$TOOLCHAIN/bin/arm-linux-androideabi-gcc"

FF_ASSEMBLER_SUB_DIRS="arm"
FF_MODULE_DIRS="compat libpostproc libavcodec libavfilter libavformat libavutil libswresample libswscale"
FF_C_OBJ_FILES=
FF_ASM_OBJ_FILES=
for MODULE_DIR in $FF_MODULE_DIRS
do
    C_OBJ_FILES="$MODULE_DIR/*.o"
    if ls $C_OBJ_FILES 1> /dev/null 2>&1; then
        echo "link $MODULE_DIR/*.o"
        FF_C_OBJ_FILES="$FF_C_OBJ_FILES $C_OBJ_FILES"
    fi

    for ASM_SUB_DIR in $FF_ASSEMBLER_SUB_DIRS
    do
        ASM_OBJ_FILES="$MODULE_DIR/$ASM_SUB_DIR/*.o"
        if ls $ASM_OBJ_FILES 1> /dev/null 2>&1; then
            echo "link $MODULE_DIR/$ASM_SUB_DIR/*.o"
            FF_ASM_OBJ_FILES="$FF_ASM_OBJ_FILES $ASM_OBJ_FILES"
        fi
    done
done
$CC -lm -lz -shared --sysroot=$SYSROOT -Wl,--no-undefined -Wl,-z,noexecstack $EXTRA_LDFLAGS $FF_C_OBJ_FILES $FF_ASM_OBJ_FILES -o $PREFIX/libffmpeg.so
  cp $PREFIX/libffmpeg.so $PREFIX/libffmpeg-debug.so
  $STRIP --strip-unneeded $PREFIX/libffmpeg.so
