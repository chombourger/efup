##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

ifndef WITH_SYSTEM_UTIL_LINUX

S = $(LOCAL_PATH)/external/util-linux

include $(CLEAR_VARS)

LOCAL_MODULE := blkid

LOCAL_CFLAGS +=				\
	-include $(S)/config.h

LOCAL_C_INCLUDES +=			\
	$(S)/include			\
	$(S)/libblkid/src

LOCAL_SRC_FILES += 					\
	$(S)/lib/at.c					\
	$(S)/lib/blkdev.c				\
	$(S)/lib/canonicalize.c				\
	$(S)/lib/crc32.c				\
	$(S)/lib/crc64.c				\
	$(S)/lib/env.c					\
	$(S)/lib/fileutils.c				\
	$(S)/lib/linux_version.c			\
	$(S)/lib/md5.c					\
	$(S)/lib/strutils.c				\
	$(S)/lib/sysfs.c				\
	$(wildcard $(S)/libblkid/src/*.c)		\
	$(wildcard $(S)/libblkid/src/partitions/*.c)	\
	$(wildcard $(S)/libblkid/src/superblocks/*.c)	\
	$(wildcard $(S)/libblkid/src/topology/*.c)

include $(BUILD_STATIC_LIBRARY)

##############################################################################

include $(CLEAR_VARS)

LOCAL_MODULE := uuid

LOCAL_SRC_FILES +=					\
	$(S)/libuuid/src/gen_uuid.c			\
	$(S)/libuuid/src/pack.c				\
	$(S)/libuuid/src/parse.c			\
	$(S)/libuuid/src/unpack.c			\
	$(S)/libuuid/src/unparse.c			\
	$(S)/lib/randutils.c

LOCAL_CFLAGS +=						\
	-include $(S)/config.h

LOCAL_C_INCLUDES +=					\
	$(S)/include

include $(BUILD_STATIC_LIBRARY)

##############################################################################

include $(CLEAR_VARS)

LOCAL_MODULE := fdisk

LOCAL_SRC_FILES +=				\
	$(wildcard $(S)/libfdisk/src/*.c)

LOCAL_CFLAGS +=					\
	-include $(S)/config.h

LOCAL_C_INCLUDES +=				\
	$(S)/include				\
	$(S)/libuuid/src

include $(BUILD_STATIC_LIBRARY)

endif # WITH_SYSTEM_UTIL_LINUX

##############################################################################

