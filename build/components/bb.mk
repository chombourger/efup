$(outdir)/bb/.config: build/components/bb.cfg
	$(MKDIR_P) $(dir $@)
	install -m 644 $< $@

.PHONY: build_bb

out/target/bb/Makefile: $(outdir)/bb/.config
	$(MAKE) -C external/busybox O=$(CURDIR)/$(outdir)/bb CC="$(CC)" CFLAGS="$(CFLAGS)" oldconfig

build_bb: out/target/bb/Makefile
	$(MAKE) -C external/busybox O=$(CURDIR)/$(outdir)/bb	\
		CC="$(CC)"					\
		CFLAGS="$(CFLAGS)"				\
		STRIP="$(STRIP)"				\
		$(if $(V),V=1)					\
		install

build_targets += build_bb
clean_targets += $(outdir)/bb
