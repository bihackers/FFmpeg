#!/bin/bash
NDK=$ANDROID_NDK 
SYSROOT=$NDK/platforms/android-21/arch-x86_64/
TOOLCHAIN=$NDK/toolchains/x86_64-4.9/prebuilt/darwin-x86_64
mkdir -p ./tmp
export TMPDIR=./tmp
OLD=""
ADDI_CFLAGS=
ADDI_LDFLAGS=
ADDITIONAL_CONFIGURE_FLAG="--disable-everything --enable-cross-compile --enable-debug --disable-programs \
                 --enable-asm --enable-neon --enable-doc --enable-pic --enable-memalign-hack --enable-small \
                 --enable-decoder=h264  --enable-encoder=aac --enable-decoder=pcm_mulaw  --disable-demuxers --disable-parsers --disable-protocols  \
                 "
export CC="$TOOLCHAIN/bin/x86_64-linux-android-gcc"
export LD=$TOOLCHAIN/bin/x86_64-linux-android-ld
export AR=$TOOLCHAIN/bin/x86_64-linux-android-ar
export STRIP=$TOOLCHAIN/bin/x86_64-linux-android-strip
function build_one
{
./configure \
--prefix=$PREFIX \
--disable-shared \
--enable-static \
--disable-ffserver \
--enable-cross-compile \
--cross-prefix=$TOOLCHAIN/bin/x86_64-linux-android- \
--target-os=linux \
--arch=x86_64 \
--sysroot=$SYSROOT \
--extra-cflags="-Os -fpic $ADDI_CFLAGS" \
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
--enable-yasm \
--enable-network
}
CPU=x86_64
ADDI_LDFLAGS=
PREFIX=android_ffmpeg_build/x86_64
mkdir -p $PREFIX
ADDI_CFLAGS=
build_one
make clean
make -j4 || exit 1
make install || exit 1
cp config.h ./android_ffmpeg_build/x86_64
FF_ASSEMBLER_SUB_DIRS="x86"
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
