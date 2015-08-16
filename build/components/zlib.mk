##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

ifndef WITH_SYSTEM_ZLIB

include $(CLEAR_VARS)
LOCAL_MODULE := z

ZLIB = $(LOCAL_PATH)/external/zlib

LOCAL_C_INCLUDES += $(ZLIB)

LOCAL_SRC_FILES += 		\
	$(ZLIB)/adler32.c	\
	$(ZLIB)/crc32.c		\
	$(ZLIB)/deflate.c	\
	$(ZLIB)/gzclose.c	\
	$(ZLIB)/gzlib.c		\
	$(ZLIB)/gzread.c	\
	$(ZLIB)/gzwrite.c	\
	$(ZLIB)/infback.c	\
	$(ZLIB)/inffast.c	\
	$(ZLIB)/inflate.c	\
	$(ZLIB)/inftrees.c	\
	$(ZLIB)/trees.c		\
	$(ZLIB)/uncompr.c	\
	$(ZLIB)/zutil.c		\

include $(BUILD_STATIC_LIBRARY)

endif # WITH_SYSTEM_ZLIB

##############################################################################

