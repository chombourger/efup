##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

ifdef DO_BUILD_DIRECTFB

include $(CLEAR_VARS)
LOCAL_MODULE := directfb

DFB = $(LOCAL_PATH)/external/directfb
DATADIR = ${exec_prefix}/data/directfb
MODULEDIR = ${exec_prefix}/lib/directfb
SYSCONFDIR = /etc

LOCAL_CPPFLAGS +=						\
	$(LIBPNG_CFLAGS)					\
	-D_GNU_SOURCE						\
	-DDATADIR=\"${RUNTIME_SYSROOT}$(DATADIR)\"		\
	-DMODULEDIR=\"${RUNTIME_SYSROOT}$(MODULEDIR)\"		\
	-DSYSCONFDIR=\"${RUNTIME_SYSROOT}$(SYSCONFDIR)\"	\
	-DDIRECTFB_VERSION=\"$(DIRECTFB_VERSION)\"		\
	"-DBUILDTIME=\"`date -u '+%Y-%m-%d %H:%M'`\""		\
	-DFLUXED_ARGS_BYTES=$(FLUXED_ARGS_BYTES)

LOCAL_C_INCLUDES +=						\
	$(DFB)							\
	$(DFB)/include						\
	$(DFB)/lib						\
	$(DFB)/src						\
	$(DFB)/systems						\
	$(JPEG_C_INCLUDES)					\
	$(PNG_C_INCLUDES)					\
	$(FREETYPE_C_INCLUDES)

LOCAL_SRC_FILES += 								\
	$(ppcasm_sources)							\
        $(armasm_sources)							\
	$(DFB)/lib/direct/clock.c						\
	$(DFB)/lib/direct/conf.c						\
	$(DFB)/lib/direct/debug.c						\
	$(DFB)/lib/direct/direct.c						\
	$(DFB)/lib/direct/direct_result.c					\
	$(DFB)/lib/direct/fastlz.c						\
	$(DFB)/lib/direct/fifo.c						\
	$(DFB)/lib/direct/flz.c							\
	$(DFB)/lib/direct/hash.c						\
	$(DFB)/lib/direct/init.c						\
	$(DFB)/lib/direct/interface.c						\
	$(DFB)/lib/direct/list.c						\
	$(DFB)/lib/direct/log.c							\
	$(DFB)/lib/direct/log_domain.c						\
	$(DFB)/lib/direct/map.c							\
	$(DFB)/lib/direct/mem.c							\
	$(DFB)/lib/direct/memcpy.c						\
	$(DFB)/lib/direct/messages.c						\
	$(DFB)/lib/direct/modules.c						\
	$(DFB)/lib/direct/print.c						\
	$(DFB)/lib/direct/processor.c						\
	$(DFB)/lib/direct/result.c						\
	$(DFB)/lib/direct/serial.c						\
	$(DFB)/lib/direct/signals.c						\
	$(DFB)/lib/direct/stream.c						\
	$(DFB)/lib/direct/system.c						\
	$(DFB)/lib/direct/trace.c						\
	$(DFB)/lib/direct/tree.c						\
	$(DFB)/lib/direct/thread.c						\
	$(DFB)/lib/direct/utf8.c						\
	$(DFB)/lib/direct/util.c						\
	$(DFB)/lib/direct/uuid.c						\
	$(DFB)/lib/direct/os/linux/glibc/clock.c				\
	$(DFB)/lib/direct/os/linux/glibc/deprecated.c				\
	$(DFB)/lib/direct/os/linux/glibc/filesystem.c				\
	$(DFB)/lib/direct/os/linux/glibc/log.c					\
	$(DFB)/lib/direct/os/linux/glibc/mem.c					\
	$(DFB)/lib/direct/os/linux/glibc/mutex.c				\
	$(DFB)/lib/direct/os/linux/glibc/system.c				\
	$(DFB)/lib/direct/os/linux/glibc/thread.c				\
	$(DFB)/lib/direct/os/linux/glibc/util.c					\
	$(DFB)/lib/fusion/arena.c						\
	$(DFB)/lib/fusion/call.c						\
	$(DFB)/lib/fusion/fusion.c						\
	$(DFB)/lib/fusion/lock.c						\
	$(DFB)/lib/fusion/object.c						\
	$(DFB)/lib/fusion/property.c						\
	$(DFB)/lib/fusion/reactor.c						\
	$(DFB)/lib/fusion/ref.c							\
	$(DFB)/lib/fusion/conf.c						\
	$(DFB)/lib/fusion/hash.c						\
	$(DFB)/lib/fusion/init.c						\
	$(DFB)/lib/fusion/shmalloc.c						\
	$(DFB)/lib/fusion/vector.c						\
	$(DFB)/lib/fusion/shm/fake.c						\
	$(DFB)/src/directfb.c							\
        $(DFB)/src/directfb_result.c						\
        $(DFB)/src/dummy.cpp							\
        $(DFB)/src/init.c							\
	$(DFB)/src/idirectfb.c							\
        $(DFB)/src/gfx/clip.c							\
        $(DFB)/src/gfx/convert.c						\
        $(DFB)/src/gfx/util.c							\
        $(DFB)/src/gfx/generic/generic.c					\
        $(DFB)/src/gfx/generic/generic_fill_rectangle.c				\
        $(DFB)/src/gfx/generic/generic_draw_line.c				\
        $(DFB)/src/gfx/generic/generic_blit.c					\
        $(DFB)/src/gfx/generic/generic_stretch_blit.c				\
        $(DFB)/src/gfx/generic/generic_texture_triangles.c			\
        $(DFB)/src/gfx/generic/generic_util.c					\
	$(DFB)/src/core/CoreDFB.cpp						\
	$(DFB)/src/core/CoreDFB_real.cpp					\
	$(DFB)/src/core/CoreSlave.cpp						\
	$(DFB)/src/core/CoreSlave_real.cpp					\
	$(DFB)/src/core/CoreGraphicsState.cpp					\
	$(DFB)/src/core/CoreGraphicsState_real.cpp				\
	$(DFB)/src/core/CoreGraphicsStateClient.cpp				\
	$(DFB)/src/core/CoreInputDevice.cpp					\
	$(DFB)/src/core/CoreInputDevice_real.cpp				\
	$(DFB)/src/core/CoreLayer.cpp						\
	$(DFB)/src/core/CoreLayer_real.cpp					\
	$(DFB)/src/core/CoreLayerContext.cpp					\
	$(DFB)/src/core/CoreLayerContext_real.cpp				\
	$(DFB)/src/core/CoreLayerRegion.cpp					\
	$(DFB)/src/core/CoreLayerRegion_real.cpp				\
	$(DFB)/src/core/CorePalette.cpp						\
	$(DFB)/src/core/CorePalette_real.cpp					\
	$(DFB)/src/core/CoreScreen.cpp						\
	$(DFB)/src/core/CoreScreen_real.cpp					\
	$(DFB)/src/core/CoreSurface.cpp						\
	$(DFB)/src/core/CoreSurface_real.cpp					\
	$(DFB)/src/core/CoreSurfaceClient.cpp					\
	$(DFB)/src/core/CoreSurfaceClient_real.cpp				\
	$(DFB)/src/core/CoreWindow.cpp						\
	$(DFB)/src/core/CoreWindow_real.cpp					\
	$(DFB)/src/core/CoreWindowStack.cpp					\
	$(DFB)/src/core/CoreWindowStack_real.cpp				\
	$(DFB)/src/core/clipboard.c						\
	$(DFB)/src/core/colorhash.c						\
	$(DFB)/src/core/core.c							\
	$(DFB)/src/core/core_parts.c						\
	$(DFB)/src/core/fonts.c							\
	$(DFB)/src/core/gfxcard.c						\
	$(DFB)/src/core/graphics_state.c					\
	$(DFB)/src/core/input.c							\
	$(DFB)/src/core/input_hub.c						\
	$(DFB)/src/core/layer_context.c						\
	$(DFB)/src/core/layer_control.c						\
	$(DFB)/src/core/layer_region.c						\
	$(DFB)/src/core/layers.c						\
	$(DFB)/src/core/local_surface_pool.c					\
	$(DFB)/src/core/palette.c						\
	$(DFB)/src/core/prealloc_surface_pool.c					\
	$(DFB)/src/core/prealloc_surface_pool_bridge.c				\
	$(DFB)/src/core/screen.c						\
	$(DFB)/src/core/screens.c						\
	$(DFB)/src/core/shared_secure_surface_pool.c				\
	$(DFB)/src/core/shared_surface_pool.c					\
	$(DFB)/src/core/state.c							\
	$(DFB)/src/core/surface.c						\
	$(DFB)/src/core/surface_allocation.c					\
	$(DFB)/src/core/surface_buffer.c					\
	$(DFB)/src/core/surface_client.c					\
	$(DFB)/src/core/surface_core.c						\
	$(DFB)/src/core/surface_pool.c						\
	$(DFB)/src/core/surface_pool_bridge.c					\
	$(DFB)/src/core/system.c						\
	$(DFB)/src/core/windows.c						\
	$(DFB)/src/core/windowstack.c						\
	$(DFB)/src/core/wm.c							\
	$(DFB)/src/display/idirectfbpalette.c					\
	$(DFB)/src/display/idirectfbsurface.c					\
	$(DFB)/src/display/idirectfbsurface_layer.c 				\
	$(DFB)/src/display/idirectfbsurface_window.c				\
	$(DFB)/src/display/idirectfbdisplaylayer.c				\
	$(DFB)/src/display/idirectfbscreen.c					\
	$(DFB)/src/input/idirectfbinputbuffer.c					\
	$(DFB)/src/input/idirectfbinputdevice.c					\
	$(DFB)/src/windows/idirectfbwindow.c					\
	$(DFB)/src/media/idirectfbdatabuffer_client.c				\
	$(DFB)/src/media/idirectfbfont.c					\
	$(DFB)/src/media/idirectfbimageprovider.c				\
	$(DFB)/src/media/idirectfbimageprovider_client.c			\
	$(DFB)/src/media/idirectfbvideoprovider.c				\
	$(DFB)/src/media/DataBuffer.cpp						\
	$(DFB)/src/media/DataBuffer.h						\
	$(DFB)/src/media/DataBuffer_includes.h					\
	$(DFB)/src/media/DataBuffer_real.cpp					\
	$(DFB)/src/media/ImageProvider.cpp					\
	$(DFB)/src/media/ImageProvider.h					\
	$(DFB)/src/media/ImageProvider_includes.h				\
	$(DFB)/src/media/ImageProvider_real.cpp					\
	$(DFB)/src/media/idirectfbdatabuffer.c					\
	$(DFB)/src/media/idirectfbdatabuffer_file.c				\
	$(DFB)/src/media/idirectfbdatabuffer_memory.c				\
	$(DFB)/src/media/idirectfbdatabuffer_streamed.c				\
	$(DFB)/src/misc/conf.c							\
	$(DFB)/src/misc/gfx_util.c						\
	$(DFB)/src/misc/util.c							\
	$(DFB)/inputdrivers/linux_input/linux_input.c				\
	$(DFB)/systems/fbdev/agp.c						\
	$(DFB)/systems/fbdev/fbdev.c						\
	$(DFB)/systems/fbdev/fbdev_surface_pool.c				\
	$(DFB)/systems/fbdev/surfacemanager.c					\
	$(DFB)/systems/fbdev/vt.c						\
	$(DFB)/wm/default/default.c						\
	$(DFB)/interfaces/IDirectFBFont/idirectfbfont_ft2.c

ifdef USE_JPEG
LOCAL_SRC_FILES += 								\
	$(DFB)/interfaces/IDirectFBImageProvider/idirectfbimageprovider_jpeg.c
endif

ifdef USE_PNG
LOCAL_SRC_FILES += 								\
	$(DFB)/interfaces/IDirectFBImageProvider/idirectfbimageprovider_png.c
endif

LOCAL_STATIC_LIBRARIES = $(JPEG_STATIC_LIBRARIES) $(PNG_STATIC_LIBRARIES)

include $(BUILD_STATIC_LIBRARY)

endif # DO_BUILD_DIRECTFB

##############################################################################
