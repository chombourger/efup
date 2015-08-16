##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

ifndef WITH_SYSTEM_FREETYPE

include $(CLEAR_VARS)
LOCAL_MODULE := ft2

FT2 = $(LOCAL_PATH)/external/freetype

LOCAL_CFLAGS += -DTT_CONFIG_OPTION_BYTECODE_INTERPRETER
LOCAL_C_INCLUDES += $(FT2)/include

LOCAL_SRC_FILES += 			\
	$(FT2)/src/gzip/ftgzip.c	\
	$(FT2)/src/autohint/ahangles.c	\
	$(FT2)/src/autohint/ahglobal.c	\
	$(FT2)/src/autohint/ahglyph.c	\
	$(FT2)/src/autohint/ahhint.c	\
	$(FT2)/src/autohint/ahmodule.c	\
	$(FT2)/src/base/ftsystem.c	\
	$(FT2)/src/base/ftinit.c	\
	$(FT2)/src/base/ftglyph.c	\
	$(FT2)/src/base/ftmm.c		\
	$(FT2)/src/base/ftbdf.c		\
	$(FT2)/src/base/ftbbox.c	\
	$(FT2)/src/base/ftdebug.c	\
	$(FT2)/src/base/ftxf86.c	\
	$(FT2)/src/base/fttype1.c	\
	$(FT2)/src/base/ftpfr.c		\
	$(FT2)/src/base/ftstroke.c	\
	$(FT2)/src/base/ftwinfnt.c	\
	$(FT2)/src/bdf/bdfdrivr.c	\
	$(FT2)/src/bdf/bdflib.c		\
	$(FT2)/src/cache/ftlru.c	\
	$(FT2)/src/cache/ftcmanag.c	\
	$(FT2)/src/cache/ftccache.c	\
	$(FT2)/src/cache/ftcglyph.c	\
	$(FT2)/src/cache/ftcsbits.c	\
	$(FT2)/src/cache/ftcimage.c	\
	$(FT2)/src/cache/ftccmap.c	\
	$(FT2)/src/cff/cffdrivr.c	\
	$(FT2)/src/cff/cffgload.c	\
	$(FT2)/src/cff/cffload.c	\
	$(FT2)/src/cff/cffobjs.c	\
	$(FT2)/src/cff/cffparse.c	\
	$(FT2)/src/cff/cffcmap.c	\
	$(FT2)/src/cid/cidobjs.c	\
	$(FT2)/src/cid/cidload.c	\
	$(FT2)/src/cid/cidgload.c	\
	$(FT2)/src/cid/cidriver.c	\
	$(FT2)/src/cid/cidparse.c	\
	$(FT2)/src/pcf/pcfdrivr.c	\
	$(FT2)/src/pcf/pcfread.c	\
	$(FT2)/src/pcf/pcfutil.c	\
	$(FT2)/src/pfr/pfrdrivr.c	\
	$(FT2)/src/pfr/pfrgload.c	\
	$(FT2)/src/pfr/pfrload.c	\
	$(FT2)/src/pfr/pfrobjs.c	\
	$(FT2)/src/pfr/pfrcmap.c	\
	$(FT2)/src/pfr/pfrsbit.c	\
	$(FT2)/src/psaux/psauxmod.c	\
	$(FT2)/src/psaux/psobjs.c	\
	$(FT2)/src/psaux/t1decode.c	\
	$(FT2)/src/psaux/t1cmap.c	\
	$(FT2)/src/pshinter/pshrec.c	\
	$(FT2)/src/pshinter/pshglob.c	\
	$(FT2)/src/pshinter/pshalgo.c	\
	$(FT2)/src/pshinter/pshmod.c	\
	$(FT2)/src/psnames/psmodule.c	\
	$(FT2)/src/raster/ftraster.c	\
	$(FT2)/src/raster/ftrend1.c	\
	$(FT2)/src/smooth/ftgrays.c	\
	$(FT2)/src/smooth/ftsmooth.c	\
	$(FT2)/src/sfnt/sfobjs.c	\
	$(FT2)/src/sfnt/sfdriver.c	\
	$(FT2)/src/sfnt/ttcmap.c	\
	$(FT2)/src/sfnt/ttcmap0.c	\
	$(FT2)/src/sfnt/ttpost.c	\
	$(FT2)/src/sfnt/ttload.c	\
	$(FT2)/src/sfnt/ttsbit.c	\
	$(FT2)/src/truetype/ttdriver.c	\
	$(FT2)/src/truetype/ttobjs.c	\
	$(FT2)/src/truetype/ttpload.c	\
	$(FT2)/src/truetype/ttgload.c	\
	$(FT2)/src/truetype/ttinterp.c	\
	$(FT2)/src/type1/t1afm.c	\
	$(FT2)/src/type1/t1driver.c	\
	$(FT2)/src/type1/t1objs.c	\
	$(FT2)/src/type1/t1load.c	\
	$(FT2)/src/type1/t1gload.c	\
	$(FT2)/src/type1/t1parse.c	\
	$(FT2)/src/type42/t42objs.c	\
	$(FT2)/src/type42/t42parse.c	\
	$(FT2)/src/type42/t42drivr.c	\
	$(FT2)/src/winfonts/winfnt.c	\
)

include $(BUILD_STATIC_LIBRARY)

endif # WITH_SYSTEM_SDL

##############################################################################

