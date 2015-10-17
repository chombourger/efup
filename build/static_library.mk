# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module:=$(LOCAL_MODULE)

include build/objects.mk

build_targets := $(build_targets) $(outdir)/lib$(module).a
clean_targets := $(clean_targets) $(outdir)/lib$(module).a

$(outdir)/lib$(module).a: module:=$(module)
$(outdir)/lib$(module).a: $($(module)_o_files)
	@echo AR $(module)
	$(Q) mkdir -p $(dir $@)
	$(Q) $(AR) r $@ $^

$($(module)_o_files): $($(module)_gen_c_files) $($(module)_gen_h_files)
