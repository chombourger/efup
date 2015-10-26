##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

ifdef DO_BUILD_OPKG

S := $(LOCAL_PATH)/external/opkg

##############################################################################
# opkglib                                                                    #
##############################################################################

include $(CLEAR_VARS)

LOCAL_MODULE     := opkglib
LOCAL_VISIBILITY := default

LOCAL_C_INCLUDES += $(S)
LOCAL_C_INCLUDES += $(ARCHIVE_C_INCLUDES)
LOCAL_C_INCLUDES += $(CURL_C_INCLUDES)

LOCAL_CFLAGS     += -DDATADIR=\"$(datadir)\"
LOCAL_CFLAGS     += -DHOST_CPU_STR=\"$(host_cpu)\"

c_files          :=
c_files          += $(wildcard $(S)/libopkg/*.c)

excl_c_files     :=
excl_c_files     += $(S)/libopkg/opkg_download_wget.c
excl_c_files     += $(S)/libopkg/opkg_gpg.c
excl_c_files     += $(S)/libopkg/opkg_openssl.c

LOCAL_SRC_FILES  += $(filter-out $(excl_c_files),$(c_files))

include $(BUILD_STATIC_LIBRARY)

##############################################################################
# opkg                                                                       #
##############################################################################

include $(CLEAR_VARS)

LOCAL_MODULE           := opkgprog

LOCAL_C_INCLUDES       += $(S)
LOCAL_C_INCLUDES       += $(S)/libopkg

LOCAL_CFLAGS           += -Dmain=opkg_main
LOCAL_CFLAGS           += -DVERSION=\"$(OPKG_VERSION)\"

c_files                :=
c_files                += $(wildcard $(S)/src/*.c)
excl_c_files           :=
LOCAL_SRC_FILES        += $(filter-out $(excl_c_files),$(c_files))

LOCAL_LDFLAGS          := $(ZLIB_LDFLAGS)
LOCAL_LDLIBS           := $(NSS_LIBS) $(NSPR_LIBS) $(ZLIB_LDLIBS)

LOCAL_STATIC_LIBRARIES += opkglib
LOCAL_STATIC_LIBRARIES += $(ARCHIVE_STATIC_LIBRARIES)
LOCAL_STATIC_LIBRARIES += $(CURL_STATIC_LIBRARIES)
LOCAL_STATIC_LIBRARIES += $(ZLIB_STATIC_LIBRARIES)

LOCAL_SHARED_LIBRARIES := $(NSS_SHARED_LIBRARIES)
LOCAL_SHARED_LIBRARIES += $(NSPR_SHARED_LIBRARIES)

include $(BUILD_STATIC_LIBRARY)

endif # DO_BUILD_OPKG

##############################################################################

