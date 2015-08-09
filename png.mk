##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

ifndef WITH_SYSTEM_PNG

include $(CLEAR_VARS)
LOCAL_MODULE := png

PNG = $(LOCAL_PATH)/external/png

LOCAL_CFLAGS += -funroll-loops
LOCAL_CFLAGS += -DHAVE_CONFIG_H
LOCAL_C_INCLUDES += . include/png $(PNG)

LOCAL_SRC_FILES += 		\
	$(PNG)/png.c		\
	$(PNG)/pngerror.c	\
	$(PNG)/pngget.c		\
	$(PNG)/pngmem.c		\
	$(PNG)/pngpread.c	\
	$(PNG)/pngread.c	\
	$(PNG)/pngrio.c		\
	$(PNG)/pngrtran.c	\
	$(PNG)/pngrutil.c	\
	$(PNG)/pngset.c		\
	$(PNG)/pngtrans.c	\
	$(PNG)/pngwio.c		\
	$(PNG)/pngwrite.c	\
	$(PNG)/pngwtran.c	\
	$(PNG)/pngwutil.c

include $(BUILD_STATIC_LIBRARY)

endif # WITH_SYSTEM_JPEG

##############################################################################

