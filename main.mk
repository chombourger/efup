##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

extra_sys_libs :=

ifdef LUA_INCLUDE
WITH_SYSTEM_LUA:=1
endif

ifdef NSPR_LIBS
WITH_SYSTEM_NSPR:=1
endif

ifdef NSS_LIBS
WITH_SYSTEM_NSS:=1
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
extra_sys_libs += png
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

