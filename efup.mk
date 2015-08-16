##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

SHLIB_PREFIX=lib
SHLIB_SUFFIX=so

ifndef WITH_SYSTEM_LUA

LUA_C_INCLUDES :=			\
	external/lua/src		\

LUA_STATIC_LIBRARIES :=			\
	lua

endif

ifndef WITH_SYSTEM_NSPR

NSPR_SHLIB_VERSION=4

NSPR_C_INCLUDES :=			\
	.				\
	include/nspr			\
	external/nspr/pr/include	\
	external/nspr/lib/ds		\
	external/nspr/lib/libc/include	\

NSPR_SHARED_LIBRARIES :=		\
	nspr$(NSPR_SHLIB_VERSION)	\
	pthread dl			\

endif # WITH_SYSTEM_NSPR

ifndef WITH_SYSTEM_NSS

FREEBL_SHLIB_VERSION=3
NSS_SHLIB_VERSION=3
NSSDBM_SHLIB_VERSION=3
NSSUTIL_SHLIB_VERSION=3
SOFTOKEN_SHLIB_VERSION=3
SSL_SHLIB_VERSION=3

NSS_C_INCLUDES :=			\
	external/nss/lib/certdb		\
	external/nss/lib/cryptohi	\
	external/nss/lib/nss		\
	external/nss/lib/pk11wrap	\
	external/nss/lib/smime		\
	external/nss/lib/util		\

NSS_SHARED_LIBRARIES :=			\
	nss$(NSS_SHLIB_VERSION)		\
	nssutil$(NSSUTIL_SHLIB_VERSION)	\
	freebl$(FREEBL_SHLIB_VERSION)	\

endif

ifndef WITH_SYSTEM_DIRECTFB

DFB_INCLUDES :=				\
	external/directfb/include	\
	external/directfb/lib

DFB_STATIC_LIBRARIES :=			\
	directfb
	
endif

ifndef WITH_SYSTEM_PNG

PNG_C_INCLUDES := 			\
	include/png			\
	external/png			\
	.

PNG_STATIC_LIBRARIES = png

endif

ifndef WITH_SYSTEM_ZLIB

ZLIB_C_INCLUDES :=			\
	external/zlib

ZLIB_STATIC_LIBRARIES = z

endif

##############################################################################

include $(CLEAR_VARS)
LOCAL_MODULE := efup

LOCAL_C_INCLUDES += 			\
	.				\
	include				\
	include/libzip			\
	$(LUA_C_INCLUDES)		\
	$(NSS_C_INCLUDES)		\
	$(NSPR_C_INCLUDES)		\
	$(DFB_INCLUDES)

LOCAL_SRC_FILES +=			\
	src/extract.c			\
	src/format.c			\
	src/fstab.c			\
	src/main.c			\
	src/mount.c			\
	src/mtab.c			\
	src/run.c			\
	src/scripting.c			\
	src/source.c			\
	src/source_local_folder.c	\
	src/source_local_zip.c		\
	src/ui/directfb.c		\
	src/verifier/nss.c		\
	src/volume.c			\

LOCAL_CFLAGS += -Wall $(LUA_INCLUDE) $(NSS_CFLAGS) $(NSPR_CFLAGS)
LOCAL_LDFLAGS += $(LIBPNG_LDFLAGS) $(ZLIB_LDFLAGS)
LOCAL_LDLIBS += $(LUA_LIB) $(NSS_LIBS) $(NSPR_LIBS8) $(LIBPNG_LDLIBS) $(ZLIB_LDLIBS)

LOCAL_STATIC_LIBRARIES += 		\
	$(LUA_STATIC_LIBRARIES)		\
	zip				\
	$(DFB_STATIC_LIBRARIES)		\
	$(PNG_STATIC_LIBRARIES)		\
	$(ZLIB_STATIC_LIBRARIES)

LOCAL_SHARED_LIBRARIES :=		\
	$(NSS_SHARED_LIBRARIES)		\
	$(NSPR_SHARED_LIBRARIES)	\
	m rt

include $(BUILD_EXECUTABLE)

##################################### LIBZIP #################################

include $(CLEAR_VARS)
LOCAL_MODULE := zip

LIBZIP = $(LOCAL_PATH)/external/libzip/lib

LOCAL_C_INCLUDES += 					\
	$(LOCAL_PATH)/include/libzip			\
	$(ZLIB_C_INCLUDES)

LOCAL_SRC_FILES += 					\
	$(LIBZIP)/mkstemp.c				\
	$(LIBZIP)/zip_close.c				\
	$(LIBZIP)/zip_dirent.c				\
	$(LIBZIP)/zip_discard.c				\
	$(LIBZIP)/zip_entry.c				\
	$(LIBZIP)/zip_err_str.c				\
	$(LIBZIP)/zip_error.c				\
	$(LIBZIP)/zip_error_get.c			\
	$(LIBZIP)/zip_error_get_sys_type.c		\
	$(LIBZIP)/zip_extra_field.c			\
	$(LIBZIP)/zip_fclose.c				\
	$(LIBZIP)/zip_fdopen.c				\
	$(LIBZIP)/zip_file_get_offset.c			\
	$(LIBZIP)/zip_filerange_crc.c			\
	$(LIBZIP)/zip_fopen.c				\
	$(LIBZIP)/zip_fopen_index.c			\
	$(LIBZIP)/zip_fopen_index_encrypted.c		\
	$(LIBZIP)/zip_fread.c				\
	$(LIBZIP)/zip_get_archive_flag.c		\
	$(LIBZIP)/zip_get_compression_implementation.c	\
	$(LIBZIP)/zip_get_encryption_implementation.c	\
	$(LIBZIP)/zip_get_name.c			\
	$(LIBZIP)/zip_memdup.c				\
	$(LIBZIP)/zip_name_locate.c			\
	$(LIBZIP)/zip_new.c				\
	$(LIBZIP)/zip_open.c				\
	$(LIBZIP)/zip_set_archive_comment.c		\
	$(LIBZIP)/zip_source_buffer.c			\
	$(LIBZIP)/zip_source_close.c			\
	$(LIBZIP)/zip_source_crc.c			\
	$(LIBZIP)/zip_source_deflate.c			\
	$(LIBZIP)/zip_source_error.c			\
	$(LIBZIP)/zip_source_filep.c			\
	$(LIBZIP)/zip_source_free.c			\
	$(LIBZIP)/zip_source_function.c			\
	$(LIBZIP)/zip_source_layered.c			\
	$(LIBZIP)/zip_source_open.c			\
	$(LIBZIP)/zip_source_pkware.c			\
	$(LIBZIP)/zip_source_pop.c			\
	$(LIBZIP)/zip_source_read.c			\
	$(LIBZIP)/zip_source_stat.c			\
	$(LIBZIP)/zip_source_zip_new.c			\
	$(LIBZIP)/zip_source_window.c			\
	$(LIBZIP)/zip_stat.c				\
	$(LIBZIP)/zip_stat_index.c			\
	$(LIBZIP)/zip_stat_init.c			\
	$(LIBZIP)/zip_string.c				\
	$(LIBZIP)/zip_unchange_data.c			\
	$(LIBZIP)/zip_utf-8.c				\

include $(BUILD_STATIC_LIBRARY)

##############################################################################

include $(wildcard build/components/*.mk)

##############################################################################
