##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

include build/build.mk

LOCAL_PATH := .

sys_cflags := $(CFLAGS)
sys_libs   := dl m pthread rt z

.PHONY: all
all: build

include efup.mk

CFLAGS := $(LOCAL_CFLAGS) $(LOCAL_C_INCLUDES:%=-I%)

.PHONY: build
build: $(build_targets)

.PHONY: clean
clean:
	$(Q) rm -f $(clean_targets)

