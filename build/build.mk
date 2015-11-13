# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

CLEAR_VARS           := build/clear_vars.mk
BUILD_EXECUTABLE     := build/executable.mk
BUILD_SHARED_LIBRARY := build/shared_library.mk
BUILD_STATIC_LIBRARY := build/static_library.mk

ifndef V
Q=@
endif

%.o: %.c
	@echo CC $<
	$(Q) mkdir -p $(dir $@)
	$(Q) $(CC)			\
		-MD -MD -MF $@.mkd	\
		$($(module)_cflags)	\
		$($(module)_cppflags)	\
		-c $< -o $@

%.o: %.cpp
	@echo CC $<
	$(Q) mkdir -p $(dir $@)
	$(Q) $(CXX)			\
		-MD -MD -MF $@.mkd	\
		$($(module)_cxxflags)	\
		$($(module)_cppflags)	\
		-c $< -o $@

out/host/%.o: %.c
	@echo CC $<
	$(Q) mkdir -p $(dir $@)
	$(Q) $(BUILD_CC)		\
		-MD -MD -MF $@.mkd	\
		$($(module)_cflags)	\
		$($(module)_cppflags)	\
		-c $< -o $@

out/target/%.o: %.c
	@echo CC $<
	$(Q) mkdir -p $(dir $@)
	$(Q) $(CC) 			\
		-MD -MD -MF $@.mkd	\
		$($(module)_cflags)	\
		$($(module)_cppflags)	\
		-c $< -o $@

out/target/%.o: %.cpp
	@echo CC $<
	$(Q) mkdir -p $(dir $@)
	$(Q) $(CXX)			\
		-MD -MD -MF $@.mkd	\
		$($(module)_cxxflags)	\
		$($(module)_cppflags)	\
		-c $< -o $@

out/target/%.o: %.s
	@echo AS $<
	$(Q) mkdir -p $(dir $@)
	$(Q) $(AS)				\
		$(LOCAL_C_INCLUDES:%=-I%)	\
		$< -o $@

