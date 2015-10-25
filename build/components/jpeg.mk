##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

ifdef DO_BUILD_JPEG

include $(CLEAR_VARS)
LOCAL_MODULE := jpeg

JPEG = $(LOCAL_PATH)/external/jpeg

LOCAL_CFLAGS += -DUSING_GENERATED_CONFIG_H
LOCAL_C_INCLUDES += $(JPEG)/include

LOCAL_SRC_FILES += 			\
	$(JPEG)/jcapimin.c \
	$(JPEG)/jcapistd.c	\
	$(JPEG)/jccoefct.c	\
	$(JPEG)/jccolor.c	\
	$(JPEG)/jcdctmgr.c	\
	$(JPEG)/jchuff.c	\
        $(JPEG)/jcinit.c	\
	$(JPEG)/jcmainct.c	\
	$(JPEG)/jcmarker.c	\
	$(JPEG)/jcmaster.c	\
	$(JPEG)/jcomapi.c	\
	$(JPEG)/jcparam.c	\
        $(JPEG)/jcphuff.c	\
	$(JPEG)/jcprepct.c	\
	$(JPEG)/jcsample.c	\
	$(JPEG)/jctrans.c	\
	$(JPEG)/jdapimin.c	\
	$(JPEG)/jdapistd.c	\
        $(JPEG)/jdatadst.c	\
	$(JPEG)/jdatasrc.c	\
	$(JPEG)/jdcoefct.c	\
	$(JPEG)/jdcolor.c	\
	$(JPEG)/jddctmgr.c	\
	$(JPEG)/jdhuff.c	\
        $(JPEG)/jdinput.c	\
	$(JPEG)/jdmainct.c	\
	$(JPEG)/jdmarker.c	\
	$(JPEG)/jdmaster.c	\
	$(JPEG)/jdmerge.c	\
	$(JPEG)/jdphuff.c	\
        $(JPEG)/jdpostct.c	\
	$(JPEG)/jdsample.c	\
	$(JPEG)/jdtrans.c	\
	$(JPEG)/jerror.c	\
	$(JPEG)/jfdctflt.c	\
	$(JPEG)/jfdctfst.c	\
        $(JPEG)/jfdctint.c	\
	$(JPEG)/jidctflt.c	\
	$(JPEG)/jidctfst.c	\
	$(JPEG)/jidctint.c	\
	$(JPEG)/jidctred.c	\
	$(JPEG)/jquant1.c	\
        $(JPEG)/jquant2.c	\
	$(JPEG)/jutils.c	\
	$(JPEG)/jmemmgr.c

include $(BUILD_STATIC_LIBRARY)

endif # DO_BUILD_JPEG

##############################################################################

