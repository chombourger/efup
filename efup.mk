##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################


##############################################################################

include $(CLEAR_VARS)
LOCAL_MODULE := efup

LOCAL_C_INCLUDES += 				\
	.					\
	include					\
	$(ARCHIVE_C_INCLUDES)			\
	$(LUA_C_INCLUDES)			\
	$(NSS_C_INCLUDES)			\
	$(NSPR_C_INCLUDES)			\
	$(DFB_INCLUDES)				\
	external/util-linux/libfdisk/src	\

LOCAL_SRC_FILES +=			\
	src/extract.c			\
	src/format.c			\
	src/fstab.c			\
	src/main.c			\
	src/mdev.c			\
	src/mount.c			\
	src/mtab.c			\
	src/partmgr.c			\
	src/run.c			\
	src/scripting/main.c		\
	src/scripting/ui.c		\
	src/source.c			\
	src/source_local_folder.c	\
	src/source_local_zip.c		\
	$(if $(USE_DIRECTFB),		\
		src/ui/directfb.c,	\
		src/ui/none.c		\
	)				\
	src/verifier/nss.c		\
	src/volume.c			\

LOCAL_CFLAGS += -Wall $(LUA_INCLUDE) $(NSS_CFLAGS) $(NSPR_CFLAGS) $(DFB_CFLAGS)
LOCAL_CFLAGS += $(DO_BUILD_DIRECTFB:%=-DDO_BUILD_DIRECTFB)

LOCAL_CFLAGS += $(DO_BUILD_OPKG:%=-DUSE_OPKG)
LOCAL_CFLAGS += $(USE_JPEG:%=-DUSE_JPEG)
LOCAL_CFLAGS += $(USE_PNG:%=-DUSE_PNG)

LOCAL_LDFLAGS += $(JPEG_LDFLAGS) $(LIBPNG_LDFLAGS) $(ZLIB_LDFLAGS)
LOCAL_LDLIBS  += $(DFB_LIBS) $(LUA_LIB) $(NSS_LIBS) $(NSPR_LIBS) $(JPEG_LDLIBS) $(LIBPNG_LDLIBS) $(ZLIB_LDLIBS)

LOCAL_STATIC_LIBRARIES += 			\
	$(LUA_STATIC_LIBRARIES)			\
	$(DFB_STATIC_LIBRARIES)			\
	$(FREETYPE_STATIC_LIBRARIES)		\
	$(JPEG_STATIC_LIBRARIES)		\
	$(PNG_STATIC_LIBRARIES)			\
	$(if $(DO_BUILD_OPKG),			\
		opkgprog			\
		opkglib				\
		$(CURL_STATIC_LIBRARIES)	\
	)					\
	$(ARCHIVE_STATIC_LIBRARIES)		\
	$(ZLIB_STATIC_LIBRARIES)		\
	$(DO_BUILD_OPKG:%=opkgprog)		\
	$(DO_BUILD_OPKG:%=opkglib)		\
	fdisk					\
	uuid					\
	blkid

LOCAL_SHARED_LIBRARIES :=		\
	$(NSS_SHARED_LIBRARIES)		\
	$(NSPR_SHARED_LIBRARIES)	\
	dl m pthread rt stdc++

include $(BUILD_EXECUTABLE)

##############################################################################

include $(wildcard build/components/*.mk)

##############################################################################
