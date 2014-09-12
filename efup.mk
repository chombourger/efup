##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

SHLIB_PREFIX=lib
SHLIB_SUFFIX=so

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

##############################################################################

include $(CLEAR_VARS)
LOCAL_MODULE := efup

LOCAL_C_INCLUDES += 			\
	.				\
	include				\
	include/libzip			\
	external/lua/src		\
	$(NSS_C_INCLUDES)		\
	$(NSPR_C_INCLUDES)		\

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
	src/verifier/nss.c		\
	src/volume.c			\

LOCAL_CFLAGS += -Wall $(NSS_CFLAGS) $(NSPR_CFLAGS)
LOCAL_LDLIBS += $(NSS_LIBS) $(NSPR_LIBS)

LOCAL_STATIC_LIBRARIES += lua zip

LOCAL_SHARED_LIBRARIES :=		\
	$(NSS_SHARED_LIBRARIES)		\
	$(NSPR_SHARED_LIBRARIES)	\
	m rt z

include $(BUILD_EXECUTABLE)

###################################### LUA ###################################

include $(CLEAR_VARS)
LOCAL_MODULE := lua

LUA = $(LOCAL_PATH)/external/lua/src

LOCAL_CFLAGS += -DLUA_COMPAT_ALL -DLUA_USE_POSIX
LOCAL_C_INCLUDES += $(LUA)

LOCAL_SRC_FILES += 		\
	$(LUA)/lapi.c		\
	$(LUA)/lcode.c		\
	$(LUA)/lctype.c		\
	$(LUA)/ldebug.c		\
	$(LUA)/ldo.c		\
	$(LUA)/ldump.c		\
	$(LUA)/lfunc.c		\
	$(LUA)/lgc.c		\
	$(LUA)/llex.c		\
	$(LUA)/lmem.c		\
	$(LUA)/lobject.c	\
	$(LUA)/lopcodes.c	\
	$(LUA)/lparser.c	\
	$(LUA)/lstate.c		\
	$(LUA)/lstring.c	\
	$(LUA)/ltable.c		\
	$(LUA)/ltm.c		\
	$(LUA)/lundump.c	\
	$(LUA)/lvm.c		\
	$(LUA)/lzio.c		\
	$(LUA)/lauxlib.c	\
	$(LUA)/lbaselib.c	\
	$(LUA)/lbitlib.c	\
	$(LUA)/lcorolib.c	\
	$(LUA)/ldblib.c		\
	$(LUA)/liolib.c		\
	$(LUA)/lmathlib.c	\
	$(LUA)/loslib.c		\
	$(LUA)/lstrlib.c	\
	$(LUA)/ltablib.c	\
	$(LUA)/loadlib.c	\
	$(LUA)/linit.c		\

include $(BUILD_STATIC_LIBRARY)

##################################### LIBZIP #################################

include $(CLEAR_VARS)
LOCAL_MODULE := zip

LIBZIP = $(LOCAL_PATH)/external/libzip/lib

LOCAL_C_INCLUDES += $(LOCAL_PATH)/include/libzip

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

include nss.mk

##############################################################################
