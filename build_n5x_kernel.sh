#!/bin/bash

# Path to build your kernel
  k=~/kernel/elitebullhead
# Directory for the any kernel updater
  t=$k/packagesm
# Date to add to zip
  today=$(date +"%m_%d_%Y")

# Clean old builds
   echo "Clean"
     rm -rf $k/out
#     make clean

# Setup the build
 cd $k/arch/arm64/configs/BBKconfigsM
    for c in *
      do
        cd $k
# Setup output directory
    mkdir -p "out/$c"
    cp -R "$t/system" out/$c
    cp -R "$t/META-INF" out/$c
    cp -R "$t/patch" out/$c
    cp -R "$t/ramdisk" out/$c
    cp -R "$t/tools" out/$c
    cp -R "$t/anykernel.sh" out/$c

  z=$c-$today

TOOLCHAIN=/home/forrest/kernel/linaro-4.9_aarch64/bin/aarch64-linux-android-
export ARCH=arm64
export SUBARCH=arm64

# make mrproper
#make CROSS_COMPILE=$TOOLCHAIN -j`grep 'processor' /proc/cpuinfo | wc -l` mrproper
 
# remove backup files
find ./ -name '*~' | xargs rm
# rm compile.log

# make kernel
make 'bullhead_defconfig'
make -j`grep 'processor' /proc/cpuinfo | wc -l` CROSS_COMPILE=$TOOLCHAIN #>> compile.log 2>&1 || exit -1

# Grab zImage-dtb
   echo ""
   echo "<<>><<>>  Collecting Image.gz-dtb <<>><<>>"
   echo ""
   cp $k/arch/arm64/boot/Image.gz-dtb out/$c/Image.gz-dtb
   done
   
# Build Zip
 clear
   echo "Creating $z.zip"
     cd $k/out/$c/
       7z a -tzip -mx5 "$z.zip"
         mv $z.zip $k/out/$z.zip
# cp $k/out/$z.zip $db/$z.zip
#           rm -rf $k/out/$c
# Line below for debugging purposes,  uncomment to stop script after each config is run
#read this
