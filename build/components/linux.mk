##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

ifdef LINUX_GIT_SUBMODULE
ifndef LINUX_PATH
LINUX_PATH:=$(LINUX_GIT_SUBMODULE)
endif
endif

# Remove quotes for LINUX_MAKE_GOALS
LINUX_MAKE_GOALS:=$(subst ",,$(LINUX_MAKE_GOALS))

ifdef LINUX_PATH

LINUX_MAKE_FLAGS:=						\
	O=$(outdir)/linux					\
	ARCH=$(HOST_CPU)					\
	CROSS_COMPILE=$(patsubst %-gcc,%-,$(CC))		\
	KBUILD_SRC=$(EFUP_DIR)/$(LINUX_PATH)			\
	$(if $(LINUX_UIMAGE_LOADADDR),	\
		UIMAGE_LOADADDR=$(LINUX_UIMAGE_LOADADDR))

$(outdir)/linux/.config:
	$(MKDIR_P) $(dir $@)
	$(MAKE) -f $(EFUP_DIR)/$(LINUX_PATH)/Makefile		\
		-C $(outdir)/linux				\
		$(LINUX_MAKE_FLAGS)				\
		$(LINUX_CONFIG)

.PHONY: build_linux_targets
build_linux_targets: $(outdir)/linux/.config
	$(MKDIR_P) $(dir $@)
	$(foreach goal,$(LINUX_MAKE_GOALS) modules,			\
		$(MAKE) -f $(EFUP_DIR)/$(LINUX_PATH)/Makefile		\
			-C $(outdir)/linux				\
			$(LINUX_MAKE_FLAGS)				\
			$(goal) &&					\
	)true

.PHONY: install_linux_targets
install_linux_targets: build_linux_targets
	$(MKDIR_P) $(dir $@)
	$(MAKE) -f $(EFUP_DIR)/$(LINUX_PATH)/Makefile		\
		-C $(outdir)/linux				\
		$(LINUX_MAKE_FLAGS)				\
		INSTALL_MOD_PATH=$(D)				\
		modules_install

# build, clean and install targets
build_targets += build_linux_targets
clean_targets += $(outdir)/linux
install_targets += install_linux_targets

endif

