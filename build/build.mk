# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

CLEAR_VARS := build/clear_vars.mk

BUILD_EXECUTABLE := build/executable.mk
BUILD_SHARED_LIBRARY := build/shared_library.mk
BUILD_STATIC_LIBRARY := build/static_library.mk

ifndef V
Q=@
endif

out/%.o: %.c
	@echo CC $<
	$(Q) mkdir -p $(dir $@)
	$(Q) $(CC) $($(module)_cflags) -c $< -o $@

out/%.o: %.s
	@echo AS $<
	$(Q) mkdir -p $(dir $@)
	$(Q) $(AS) $(LOCAL_C_INCLUDES:%=-I%) $< -o $@

