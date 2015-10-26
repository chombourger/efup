##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

ifdef DO_BUILD_CURL

include $(CLEAR_VARS)

LOCAL_MODULE := curl

LOCAL_VISIBILITY := default

S = $(LOCAL_PATH)/external/curl

LOCAL_C_INCLUDES += $(S) $(S)/include $(S)/lib
LOCAL_C_INCLUDES += $(NSS_C_INCLUDES)
LOCAL_C_INCLUDES += $(NSPR_C_INCLUDES)
LOCAL_C_INCLUDES += $(ZLIB_C_INCLUDES)

LOCAL_CFLAGS     += -DHAVE_CONFIG_H
LOCAL_CFLAGS     += $(if $(USE_NSS),-DUSE_NSS)
LOCAL_CFLAGS     += $(NSS_CFLAGS)

c_files          := $(wildcard $(S)/lib/*.c)
c_files          += $(wildcard $(S)/lib/vtls/*.c)
excl_c_files     := $(S)/lib/amigaos.c
excl_c_files     += $(S)/lib/ldap.c

LOCAL_SRC_FILES  += $(filter-out $(excl_c_files),$(c_files))

include $(BUILD_STATIC_LIBRARY)

endif # DO_BUILD_CURL

##############################################################################

