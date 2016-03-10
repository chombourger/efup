# git submodule to fetch for prebuilt toolchains
TOOLCHAIN_GIT_SUBMODULE=toolchains/gcc-linaro-4.9-2015.02-3-x86_64_arm-linux-gnueabihf

# host for autoconf
HOST=arm-linux-gnueabihf

# path to the sysroot
SYSROOT=toolchains/gcc-linaro-4.9-2015.02-3-x86_64_arm-linux-gnueabihf/arm-linux-gnueabihf/libc

# git submodule to fetch u-boot from
UBOOT_GIT_SUBMODULE=boards/bcmadvancedresearch/ar6mxq/u-boot-imx

# u-boot config
UBOOT_CONFIG=ar6mx_defconfig

# git submodule to fetch the Linux kernel from
LINUX_GIT_SUBMODULE=boards/bcmadvancedresearch/ar6mxq/linux-imx6

# Linux kernel config
LINUX_CONFIG=ar6mx_defconfig

# make goals for the Linux kernel
LINUX_MAKE_GOALS="dtbs uImage"

# Load address for the Linux kernel uImage
LINUX_UIMAGE_LOADADDR=0x10008000

