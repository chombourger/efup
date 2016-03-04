##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

# busybox features to turn on if networking is enabled
bb_net_keys_yes := 				\
	CONFIG_IFCONFIG				\
	CONFIG_UDHCPC				\
	CONFIG_WGET				\
	CONFIG_FEATURE_WGET_STATUSBAR		\
	CONFIG_FEATURE_WGET_AUTHENTICATION	\

# networking features
bb_net_keys := $(bb_net_keys_$(strip $(USE_NETWORKING)))

# rule for creating the busybox .config file
$(outdir)/bb/.config: build/components/bb.cfg
	$(MKDIR_P) $(dir $@)
	install -m 644 $< $@
	$(foreach k,$(bb_net_keys),				\
		sed -i -e 's,# $(k) is not set,$(k)=y,g' $@ &&	\
	) true

# rule for configuring busybox from the created .config file
out/target/bb/Makefile: $(outdir)/bb/.config
	$(MAKE) -C external/busybox O=$(CURDIR)/$(outdir)/bb CC="$(CC)" CFLAGS="$(CFLAGS)" oldconfig

# actual rule for building busybox
out/target/bb/_install/bin/busybox:				\
	out/target/bb/Makefile
	$(MAKE) -C external/busybox O=$(CURDIR)/$(outdir)/bb	\
		CC="$(CC)"					\
		CFLAGS="$(CFLAGS)"				\
		STRIP="$(STRIP)"				\
		$(if $(V),V=1)					\
		install

# build and clean targets
build_targets += out/target/bb/_install/bin/busybox
clean_targets += $(outdir)/bb

