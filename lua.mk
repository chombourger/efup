##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

ifndef WITH_SYSTEM_LUA

include $(CLEAR_VARS)
LOCAL_MODULE := lua

LUA = $(LOCAL_PATH)/external/lua/src

LOCAL_CFLAGS     += -DLUA_COMPAT_ALL -DLUA_USE_POSIX
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

endif # WITH_SYSTEM_LUA

##############################################################################

