# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module:=$(LOCAL_MODULE)

include build/objects.mk

build_targets   := $(build_targets)   $(module)
clean_targets   := $(clean_targets)   $(module)
install_targets := $(install_targets) $(D)$(sbindir)/$(module)

$(module)_shared_libraries:=$(LOCAL_SHARED_LIBRARIES)
$(module)_static_libraries:=$(LOCAL_STATIC_LIBRARIES)

# User-defined shared libraries
$(module)_ushared_libraries:=$(filter-out $(sys_libs),		\
	$($(module)_shared_libraries)				\
)

# User-defined static libraries
$(module)_ustatic_libraries:=$(filter-out $(sys_libs),		\
	$($(module)_static_libraries)				\
)

$(module)_ldflags:=						\
	$(sys_ldflags)						\
	-L.							\
	-L$(outdir)						\

$(module)_ldlibs:=						\
	$(sys_ldlibs)						\
	$(LOCAL_LDLIBS)						\
	$($(module)_static_libraries:%=-l%)			\
	$($(module)_shared_libraries:%=-l%)			\

$(module)_deps:=						\
	$($(module)_gen_files)					\
	$($(module)_o_files)					\
	$($(module)_ushared_libraries:%=lib%.so)		\
	$($(module)_ustatic_libraries:%=$(outdir)/lib%.a)	\

$(module): module:=$(module)
$(module): $($(module)_deps)
	@echo LD $(module)
	$(Q) $(CC) -rdynamic -o $@				\
		$($(module)_cflags)				\
		$($(module)_o_files)				\
		$($(module)_ldflags)				\
		-Wl,--start-group				\
		$($(module)_ldlibs)				\
		-Wl,--end-group					\

$(D)$(sbindir)/$(module): $(module)
	$(MKDIR_P) $(dir $@)
	$(INSTALL) -m 755 $< $@

$($(module)_o_files): $($(module)_gen_c_files) $($(module)_gen_h_files)

