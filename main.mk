##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

extra_sys_libs :=

SHLIB_PREFIX=lib
SHLIB_SUFFIX=so

##############################################################################
# Lua                                                                        #
##############################################################################

ifdef LUA_INCLUDE
WITH_SYSTEM_LUA      := 1
else
LUA_C_INCLUDES       := external/lua/src
LUA_STATIC_LIBRARIES := lua
endif

##############################################################################
# DirectFB                                                                   #
##############################################################################

ifdef USE_DIRECTFB
ifdef DFB_LIBS
extra_sys_libs       += directfb
else
DO_BUILD_DIRECTFB    := 1
DO_BUILD_FREETYPE    := 1
DFB_INCLUDES         := external/directfb/include external/directfb/lib
DFB_STATIC_LIBRARIES :=	directfb
endif
endif

##############################################################################
# Freetype                                                                   #
##############################################################################

ifdef USE_FREETYPE
ifdef FT_LIBS
extra_sys_libs            += ft2
else
DO_BUILD_FREETYPE         := 1
FREETYPE_C_INCLUDES       := external/freetype/include
FREETYPE_STATIC_LIBRARIES := ft2
endif
endif

##############################################################################
# JPEG                                                                        #
##############################################################################

ifdef USE_JPEG
ifdef LIBJPEG
extra_sys_libs        += jpeg
else
DO_BUILD_JPEG         := 1
JPEG_C_INCLUDES       := external/jpeg
JPEG_STATIC_LIBRARIES := jpeg
endif
endif

##############################################################################
# PNG                                                                        #
##############################################################################

ifdef USE_PNG
ifdef LIBPNG_LIBS
extra_sys_libs       += png
else
DO_BUILD_PNG         := 1
PNG_C_INCLUDES       := include/png external/png .
PNG_STATIC_LIBRARIES := png
endif
endif

##############################################################################
# zlib                                                                       #
##############################################################################

ifdef ZLIB_LIBS
extra_sys_libs        += z
else
DO_BUILD_ZLIB         := 1
ZLIB_C_INCLUDES       := external/zlib
ZLIB_STATIC_LIBRARIES := z
endif

##############################################################################
# archive                                                                    #
##############################################################################

ifdef USE_ARCHIVE
ifdef ARCHIVE_LIBS
extra_sys_libs           += archive
else
DO_BUILD_ARCHIVE         := 1
ARCHIVE_C_INCLUDES       := external/libarchive/libarchive
ARCHIVE_STATIC_LIBRARIES := archive
endif
endif

##############################################################################
# NSPR                                                                       #
##############################################################################

ifdef USE_NSPR
ifdef NSPR_LIBS
extra_sys_libs        += $(patsubst -l%,%,$(NSPR_LIBS))
else
DO_BUILD_NSPR         := 1
NSPR_SHLIB_VERSION    := 4
NSPR_C_INCLUDES       := .
NSPR_C_INCLUDES       += include/nspr
NSPR_C_INCLUDES       += external/nspr/pr/include
NSPR_C_INCLUDES       += external/nspr/lib/ds
NSPR_C_INCLUDES       += external/nspr/lib/libc/include
NSPR_SHARED_LIBRARIES := nspr$(NSPR_SHLIB_VERSION) pthread dl
endif
endif

##############################################################################
# NSS                                                                        #
##############################################################################

ifdef USE_NSS
ifdef NSS_LIBS
extra_sys_libs         += $(patsubst -l%,%,$(NSS_LIBS))
else
DO_BUILD_NSS           := 1
FREEBL_SHLIB_VERSION   := 3
NSS_SHLIB_VERSION      := 3
NSSDBM_SHLIB_VERSION   := 3
NSSUTIL_SHLIB_VERSION  := 3
SOFTOKEN_SHLIB_VERSION := 3
SSL_SHLIB_VERSION      :=3
NSS_C_INCLUDES         := external/nss/lib/certdb
NSS_C_INCLUDES         += external/nss/lib/certhigh
NSS_C_INCLUDES         += external/nss/lib/cryptohi
NSS_C_INCLUDES         += external/nss/lib/nss
NSS_C_INCLUDES         += external/nss/lib/pkcs7
NSS_C_INCLUDES         += external/nss/lib/pk11wrap
NSS_C_INCLUDES         += external/nss/lib/smime
NSS_C_INCLUDES         += external/nss/lib/ssl
NSS_C_INCLUDES         += external/nss/lib/util
NSS_SHARED_LIBRARIES   := nss$(NSS_SHLIB_VERSION)
NSS_SHARED_LIBRARIES   += nssutil$(NSSUTIL_SHLIB_VERSION)
NSS_SHARED_LIBRARIES   += freebl$(FREEBL_SHLIB_VERSION)
NSS_SHARED_LIBRARIES   += ssl$(SSL_SHLIB_VERSION)
endif
endif

##############################################################################
# curl                                                                       #
##############################################################################

ifdef USE_CURL
ifdef CURL_LIBS
extra_sys_libs        += curl
else
DO_BUILD_CURL         := 1
CURL_C_INCLUDES       := external/curl/include
CURL_STATIC_LIBRARIES := curl
endif
endif

##############################################################################
# opkg                                                                       #
##############################################################################

ifdef USE_OPKG
DO_BUILD_OPKG := 1
endif

include build/build.mk

LOCAL_PATH := .

sys_cflags   := $(CFLAGS)
sys_cppflags := $(CPPFLAGS)
sys_ldflags  := $(LDFLAGS)
sys_libs     := dl m pthread rt stdc++ $(extra_sys_libs)

.PHONY: all
all: build

include efup.mk

CFLAGS := $(LOCAL_CFLAGS) $(LOCAL_C_INCLUDES:%=-I%)

.PHONY: build
build: $(build_targets)

.PHONY: clean
clean:
	$(Q) rm -rf $(clean_targets)

.PHONY: install
install: $(install_targets)

