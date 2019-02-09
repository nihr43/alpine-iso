#!/bin/sh
#
##

# building user needs to be in abuild group
# usermod -a -G abuild jenkins

sudo apk update
sudo apk add alpine-sdk build-base apk-tools alpine-conf busybox fakeroot syslinux xorriso squashfs-tools mtools dosfstools grub-efi

abuild-keygen -i -a

git clone https://git.alpinelinux.org/aports
cd ./aports/scripts

mkdir ../../iso
sh mkimage.sh --tag edge --outdir ../../iso --arch x86_64 --repository http://dl-cdn.alpinelinux.org/alpine/edge/main --profile standard
