#!/bin/bash
# simple bash script for executing build

RDIR=$(pwd)

TOOLCHAIN=/home/jc/build/toolchain/gcc-linaro-4.9-2016.02-x86_64_arm-linux-gnueabihf

THREADS=5

[ -z $VERSION ] && \
# version number
VERSION=$(cat $RDIR/VERSION)

export ARCH=arm
export CROSS_COMPILE=$TOOLCHAIN/bin/arm-linux-gnueabihf-

cd $RDIR

[ "$1" ] && DEVICE=$1 || DEVICE=mako
[ "$TARGET" ] || TARGET=nethunter

DEFCONFIG=${TARGET}_${DEVICE}_defconfig
FILE=arch/arm/configs/$DEFCONFIG

[ -f "$FILE" ] || {
	echo "Defconfig not found: $FILE"
	exit 1
}

export LOCALVERSION=$TARGET-$DEVICE-$VERSION

echo "Cleaning build..."
rm -rf build && mkdir build

make -C $RDIR O=build $DEFCONFIG &&
echo "Starting build for $LOCALVERSION..." &&
make -C $RDIR O=build -j"$THREADS" &&
echo "Done building $LOCALVERSION."
