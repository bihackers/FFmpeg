#!/bin/bash

rm -rf universal
mkdir -p universal

lipo -create ./arm64/lib/libavcodec.a ./armv7/lib/libavcodec.a ./armv7s/lib/libavcodec.a ./i386/lib/libavcodec.a ./x86_64/lib/libavcodec.a -output ./universal/libavcodec.a

lipo -create ./arm64/lib/libavdevice.a ./armv7/lib/libavdevice.a ./armv7s/lib/libavdevice.a ./i386/lib/libavdevice.a ./x86_64/lib/libavdevice.a -output ./universal/libavdevice.a

lipo -create ./arm64/lib/libavfilter.a ./armv7/lib/libavfilter.a ./armv7s/lib/libavfilter.a ./i386/lib/libavfilter.a ./x86_64/lib/libavfilter.a -output ./universal/libavfilter.a

lipo -create ./arm64/lib/libavformat.a ./armv7/lib/libavformat.a ./armv7s/lib/libavformat.a ./i386/lib/libavformat.a ./x86_64/lib/libavformat.a -output ./universal/libavformat.a

lipo -create ./arm64/lib/libavutil.a ./armv7/lib/libavutil.a ./armv7s/lib/libavutil.a ./i386/lib/libavutil.a ./x86_64/lib/libavutil.a -output ./universal/libavutil.a

lipo -create ./arm64/lib/libswresample.a ./armv7/lib/libswresample.a ./armv7s/lib/libswresample.a ./i386/lib/libswresample.a ./x86_64/lib/libswresample.a -output ./universal/libswresample.a

lipo -create ./arm64/lib/libswscale.a ./armv7/lib/libswscale.a ./armv7s/lib/libswscale.a ./i386/lib/libswscale.a ./x86_64/lib/libswscale.a -output ./universal/libswscale.a

lipo -create ./arm64/lib/libpostproc.a ./armv7/lib/libpostproc.a ./armv7s/lib/libpostproc.a ./i386/lib/libpostproc.a ./x86_64/lib/libpostproc.a -output ./universal/libpostproc.a

cp -f ./arm64/include ./universal




