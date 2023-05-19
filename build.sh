#!/usr/bin/env sh

VERSION=9.3
SOURCE=https://ftp.gnu.org/gnu/coreutils/coreutils-$VERSION.tar.xz

echo Downloading Coreutils "$VERSION" ...
cd /build || exit
wget "$SOURCE"

echo Extracting Coreutils "$VERSION" ...
tar -xf coreutils-$VERSION.tar.xz
mv coreutils-$VERSION coreutils

echo Building Coreutils ...
cd /build/coreutils || exit
FORCE_UNSAFE_CONFIGURE=1 CFLAGS="-static -Os -ffunction-sections -fdata-sections" LDFLAGS="-Wl,--gc-sections" ./configure
make "-j$(nproc)"
ls -l

echo Packaging Coreutils ...
mkdir /export
cd /export || exit

cp /build/coreutils/src/chroot .
strip -s -R .comment -R .gnu.version --strip-unneeded chroot
cp /build/coreutils/COPYING ./LICENSE
echo "Source  : $SOURCE" > ./SOURCE
echo "Version : $VERSION" >> ./SOURCE
echo "Package : https://github.com/vmify/coreutils/coreutils/download/$TAG/coreutils-$ARCH-$TAG.tar.gz" >> ./SOURCE

tar -czvf /coreutils.tar.gz *
