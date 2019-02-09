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

cd ../../iso

bucket="isos"
file="alpine-standard-edge-x86_64.iso"

resource="/${bucket}/${file}"
content_type="application/octet-stream"
date=`date -R`
_signature="PUT\n\n${content_type}\n${date}\n${resource}"
signature=`echo -en ${_signature} | openssl sha1 -hmac ${s3_secret} -binary | base64`

curl -v -X PUT -T "${file}" \
          -H "Host: $host" \
          -H "Date: ${date}" \
          -H "Content-Type: ${content_type}" \
          -H "Authorization: AWS ${s3_key}:${signature}" \
          http://$host${resource}
