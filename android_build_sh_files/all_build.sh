#!/bin/bash

rm -rf ../android_ffmpeg_build
rm ../ffmpeg_arm64.sh

cp ffmpeg_arm64.sh ../ffmpeg_arm64.sh

rm ../ffmpeg_armv7a.sh
cp ffmpeg_armv7a.sh ../ffmpeg_armv7a.sh

rm ../ffmpeg_armeabi.sh
cp ffmpeg_armeabi.sh ../ffmpeg_armeabi.sh

rm ../ffmpeg_x86.sh
cp ffmpeg_x86.sh ../ffmpeg_x86.sh

rm ../ffmpeg_x86_64.sh
cp ffmpeg_x86_64.sh ../ffmpeg_x86_64.sh

cd ..
rm -rf android_ffmpeg_build

find . -name "*.o"  | xargs rm -f
./ffmpeg_arm64.sh
find . -name "*.o"  | xargs rm -f
./ffmpeg_armv7a.sh
find . -name "*.o"  | xargs rm -f
./ffmpeg_armeabi.sh
find . -name "*.o"  | xargs rm -f
./ffmpeg_x86.sh
find . -name "*.o"  | xargs rm -f
./ffmpeg_x86_64.sh
find . -name "*.o"  | xargs rm -f

rm ffmpeg_arm64.sh
rm ffmpeg_armeabi.sh
rm ffmpeg_armv7a.sh
rm ffmpeg_x86.sh
rm ffmpeg_x86_64.sh
