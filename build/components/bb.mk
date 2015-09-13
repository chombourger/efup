out/bb/.config: build/components/bb.cfg
	$(MKDIR_P) $(dir $@)
	install -m 644 $< $@

.PHONY: build_bb

build_bb: out/bb/.config
	$(MAKE) -C external/busybox O=$(CURDIR)/out/bb CC="$(CC)" CFLAGS="$(CFLAGS)" oldconfig
	$(MAKE) -C external/busybox O=$(CURDIR)/out/bb CC="$(CC)" CFLAGS="$(CFLAGS)" install

build_targets += build_bb
clean_targets += out/bb
