#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# default image size
default_image_size=1G

# partition 1: type=ext2, 1-257
part1_type=ext2
part1_start=1
part1_end=257

# partition 2: type=ext4, 258-833
part2_type=ext4
part2_start=258
part2_end=833

# partition 3: type=ext4, size=<remaining space>
part3_type=ext4
part3_start=834

# path to the SPL image
spl_image=out/target/u-boot/SPL

# path to the u-boot image
uboot_image=out/target/u-boot/u-boot.img

# path to the Linux kernel image
kernel_image=out/target/linux/arch/arm/boot/uImage

# path to the DTB image
dtb_image=out/target/linux/arch/arm/boot/dts/imx6q-ar6mx.dtb

# path to the initramfs image
initramfs_image=initramfs.gz

# check presence of all required input files
# usage: check_files
check_files() {
   for f in ${uboot_image} ${kernel_image} ${dtb_image} ${initramfs_image}
   do
      if [ ! -f ${f} ]; then
         echo "${f}: file not found!" >&2
         return 1
      fi
   done
   return 0
}

# create a new image
# usage: new_image <file> <size>
new_image() {
   local image=${1}
   local size=${2:-${default_image_size}}

   rm -f ${image} &&			\
   fallocate -l ${size} ${image} &&	\
   parted -s ${image} mktable msdos
}

# partition the image
# usage: part_image <file>
part_image() {
   local image=${1}

   parted -s -a opt ${image} -- 				\
      mkpart primary ${part1_type}				\
         ${part1_start}MiB ${part1_end}MiB &&			\
   parted -s -a opt ${image} -- 				\
      mkpart primary ${part2_type}				\
         ${part2_start}MiB ${part2_end}MiB &&			\
   parted -s -a opt ${image} -- 				\
      mkpart primary ${part3_type}				\
         ${part3_start}MiB -0
}

# wrapper for the dd command
do_dd() {
   dd status=none ${*}
   return ${?}
}

# write the u-boot image
write_uboot() {
   local image=${1}
   local sts
   local tmp

   tmp=`mktemp`
   do_dd if=/dev/zero count=500 bs=1K | tr '\000' '\377' > ${tmp} &&	\
   do_dd if=${spl_image} of=${tmp} conv=notrunc &&			\
   do_dd if=${uboot_image} of=${tmp} bs=1K seek=68 conv=notrunc &&	\
   do_dd if=${tmp} of=${image} bs=512 seek=2 conv=notrunc
   sts=${?}
   rm -f ${tmp}

   return ${sts}
}

# create the boot partition
# usage: create_boot_part <boot-image>
create_boot_part() {
   local image=${1}
   local size
   local sts
   local tmp

   size=$((${part1_end} - ${part1_start}))
   tmp=`mktemp -d`
   cat > ${tmp}/boot.cmd <<EOF
setenv bootargs 'console=ttymxc0,115200 consoleblank=0 video=mxcfb0:dev=hdmi,1920x1080M@50,bpp=32'
setenv fdt_addr 0x12800000
setenv fdt_file 'imx6q-ar6mx.dtb'
setenv initramfs_addr 0x12900000
setenv initramfs_file 'uRamDisk'
setenv kernel 'uImage'
ext2load mmc \${mmcdev} \${fdt_addr} \${fdt_file}
ext2load mmc \${mmcdev} \${initramfs_addr} \${initramfs_file}
ext2load mmc \${mmcdev} \${loadaddr} \${kernel}
bootm \${loadaddr} \${initramfs_addr} \${fdt_addr}
EOF
   mkimage -A arm -O linux -T script -n "boot"  		\
      -d ${tmp}/boot.cmd ${tmp}/boot.scr >/dev/null &&		\
   rm -f ${tmp}/boot.cmd &&					\
   mkimage -A arm -O linux -T ramdisk -n "Ram Disk" -C gzip	\
      -d ${initramfs_image} ${tmp}/uRamDisk >/dev/null &&	\
   cp ${kernel_image} ${dtb_image} ${tmp} &&			\
   echo "# Creating boot partition image (${size}M)" &&		\
   genext2fs -d ${tmp} -P -b $((${size} * 1024)) ${image}
   sts=${?}
   rm -rf ${tmp}
   return ${sts}
}

# write the boot partition image to the disk image
# usage: write_boot_part <disk-image> <boot-image>
write_boot_part() {
   local disk_img=${1}
   local boot_img=${2}
   local offset

   offset=`fdisk -lu ${disk_img} |tail -n 3|head -n 1|awk '{ print $2; }'`
   do_dd if=${boot_img} of=${disk_img} bs=512 seek=${offset} conv=notrunc
}

# main
boot_img=`mktemp`
check_files &&			\
new_image ${1} &&		\
part_image ${1} &&		\
write_uboot ${1} &&		\
create_boot_part ${boot_img} &&	\
write_boot_part ${1} ${boot_img}
sts=${?}

rm -f ${boot_img}
exit ${sts}

