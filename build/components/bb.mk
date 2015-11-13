
bb_net_keys_yes := 				\
	CONFIG_IFCONFIG				\
	CONFIG_UDHCPC				\
	CONFIG_WGET				\
	CONFIG_FEATURE_WGET_STATUSBAR		\
	CONFIG_FEATURE_WGET_AUTHENTICATION	\

bb_net_keys := $(bb_net_keys_$(strip $(USE_NETWORKING)))

$(outdir)/bb/.config: build/components/bb.cfg
	$(MKDIR_P) $(dir $@)
	install -m 644 $< $@
	$(foreach k,$(bb_net_keys),				\
		sed -i -e 's,# $(k) is not set,$(k)=y,g' $@ &&	\
	) true

out/target/bb/Makefile: $(outdir)/bb/.config
	$(MAKE) -C external/busybox O=$(CURDIR)/$(outdir)/bb CC="$(CC)" CFLAGS="$(CFLAGS)" oldconfig

out/target/bb/_install/bin/busybox:				\
	out/target/bb/Makefile
	$(MAKE) -C external/busybox O=$(CURDIR)/$(outdir)/bb	\
		CC="$(CC)"					\
		CFLAGS="$(CFLAGS)"				\
		STRIP="$(STRIP)"				\
		$(if $(V),V=1)					\
		install

build_targets += out/target/bb/_install/bin/busybox
clean_targets += $(outdir)/bb
