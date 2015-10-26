##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

ifdef DO_BUILD_ARCHIVE

include $(CLEAR_VARS)

LOCAL_MODULE := archive

LOCAL_VISIBILITY := default

S = $(LOCAL_PATH)/external/libarchive

LOCAL_C_INCLUDES += $(S)
LOCAL_C_INCLUDES += $(ZLIB_C_INCLUDES)

LOCAL_CFLAGS     += -DHAVE_CONFIG_H
LOCAL_SRC_FILES  += 			\
	$(wildcard $(S)/libarchive/*.c)

include $(BUILD_STATIC_LIBRARY)

endif # DO_BUILD_ARCHIVE

##############################################################################

