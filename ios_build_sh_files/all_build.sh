#!/bin/bash

rm ../ffmpeg_arm64_ios.sh
cp ffmpeg_arm64_ios.sh ../ffmpeg_arm64_ios.sh

rm ../ffmpeg_armv7.sh
cp ffmpeg_armv7.sh ../ffmpeg_armv7.sh

rm ../ffmpeg_armv7s.sh
cp ffmpeg_armv7s.sh ../ffmpeg_armv7s.sh

rm ../ffmpeg_i386.sh
cp ffmpeg_i386.sh ../ffmpeg_i386.sh

rm ../ffmpeg_x86_64_ios.sh
cp ffmpeg_x86_64_ios.sh ../ffmpeg_x86_64_ios.sh

cd ..

rm -rf ios_ffmpeg_build

find . -name "*.o"  | xargs rm -f
./ffmpeg_arm64_ios.sh

find . -name "*.o"  | xargs rm -f
./ffmpeg_armv7.sh

find . -name "*.o"  | xargs rm -f
./ffmpeg_armv7s.sh

find . -name "*.o"  | xargs rm -f
./ffmpeg_i386.sh

find . -name "*.o"  | xargs rm -f
./ffmpeg_x86_64_ios.sh

find . -name "*.o"  | xargs rm -f

rm ffmpeg_arm64_ios.sh
rm ffmpeg_armv7.sh
rm ffmpeg_armv7s.sh
rm ffmpeg_i386.sh
rm ffmpeg_x86_64_ios.sh

cd ios_build_sh_files
cp lipo.sh ../ios_ffmpeg_build
cd ../ios_ffmpeg_build
chmod u+x lipo.sh
./lipo.sh