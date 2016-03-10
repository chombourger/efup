##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

ifdef UBOOT_GIT_SUBMODULE
ifndef UBOOT_PATH
UBOOT_PATH:=$(UBOOT_GIT_SUBMODULE)
endif
endif

ifdef UBOOT_PATH

$(outdir)/u-boot/.config:
	$(MKDIR_P) $(dir $@)
	$(MAKE) -f $(EFUP_DIR)/$(UBOOT_PATH)/Makefile		\
		-C $(outdir)/u-boot				\
		O=$(outdir)/u-boot				\
		ARCH=$(HOST_CPU)				\
		CROSS_COMPILE=$(patsubst %-gcc,%-,$(CC))	\
		KBUILD_SRC=$(EFUP_DIR)/$(UBOOT_PATH)		\
		$(UBOOT_CONFIG)

$(outdir)/u-boot/u-boot.bin: $(outdir)/u-boot/.config
	$(MKDIR_P) $(dir $@)
	$(MAKE) -f $(EFUP_DIR)/$(UBOOT_PATH)/Makefile		\
		-C $(outdir)/u-boot				\
		O=$(outdir)/u-boot				\
		ARCH=$(HOST_CPU)				\
		CROSS_COMPILE=$(patsubst %-gcc,%-,$(CC))	\
		KBUILD_SRC=$(EFUP_DIR)/$(UBOOT_PATH)		\
		$(UBOOT_MAKE_GOAL)

# build and clean targets
build_targets += out/target/u-boot/u-boot.bin
clean_targets += $(outdir)/u-boot

endif

