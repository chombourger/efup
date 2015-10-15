#include <efup/ui.h>

#include <stdio.h>
#include <unistd.h>
#include <directfb.h>

static IDirectFB *dfb = NULL;
static IDirectFBSurface *primary = NULL;
int ui_width  = 0;
int ui_height = 0;

static int ui_pb_x = 0;
static int ui_pb_y = 0;
static int ui_pb_w = 0;
static int ui_pb_h = 0;
static int ui_pb_v = 0;

static int ui_bg_r = 0;
static int ui_bg_g = 0;
static int ui_bg_b = 0;
static int ui_bg_a = 255;

static int ui_pb_border_r = 0;
static int ui_pb_border_g = 96;
static int ui_pb_border_b = 0;
static int ui_pb_border_a = 255;

static int ui_pb_fill_r = 0;
static int ui_pb_fill_g = 156;
static int ui_pb_fill_b = 0;
static int ui_pb_fill_a = 255;

#ifndef WITH_SYSTEM_DIRECTFB
void __D_init_all(void);
void *ref_d_init_all = __D_init_all;
void directfb_fbdev(void);
void *ref_directfb_fbdev = directfb_fbdev;
void directfbwm_default(void);
void *ref_directfbwm_default = directfbwm_default;
void IDirectFBImageProvider_PNG_ctor(void);
void *ref_idirectfbimageprovider_png = IDirectFBImageProvider_PNG_ctor;
void IDirectFBFont_FT2_ctor(void);
void *ref_idirectfbfont_png = IDirectFBFont_FT2_ctor;
#endif

int
ui_init(int argc, char **argv) {
    DFBSurfaceDescription dsc;
    int error;

    error = DirectFBInit(&argc, &argv);
    if (error != DFB_OK) return error;

    DirectFBSetOption("quiet", NULL);
    DirectFBSetOption("no-debug", NULL);
    DirectFBSetOption("graphics-vt", NULL);
    DirectFBSetOption("no-cursor", NULL);

    error = DirectFBCreate(&dfb);
    if (error != DFB_OK) return error;

    dfb->SetCooperativeLevel(dfb, DFSCL_FULLSCREEN);

    dsc.flags = DSDESC_CAPS;
    dsc.caps  = DSCAPS_PRIMARY;

    error = dfb->CreateSurface(dfb, &dsc, &primary);
    if (error != DFB_OK) return error;

    primary->GetSize(primary, &ui_width, &ui_height);
    primary->SetColor(primary, ui_bg_r, ui_bg_g, ui_bg_b, ui_bg_a);
    primary->FillRectangle(primary, 0, 0, ui_width, ui_height);

    return 0;
}

void
ui_destroy(void) {

    if (primary) {
        primary->Release(primary);
        primary = NULL;
    }

    if (dfb) {
       dfb->Release(dfb);
       dfb = NULL;
    }
}

void *
ui_load_image(const char *path, int *pWidth, int *pHeight) {
    IDirectFBImageProvider *provider;
    IDirectFBSurface *surface;
    DFBSurfaceDescription dsc;
    void *result = NULL;
    int status;

    if ((path != NULL) && (dfb != NULL)) {
        status = dfb->CreateImageProvider(dfb, path, &provider);
        if (status == DFB_OK) {
            status = provider->GetSurfaceDescription(provider, &dsc);
            if (status == DFB_OK) {
                if (pWidth) *pWidth = dsc.width;
                if (pHeight) *pHeight = dsc.height;
                status = dfb->CreateSurface(dfb, &dsc, &surface);
                if (status == DFB_OK) {
                    provider->RenderTo(provider, surface, NULL);
                    result = surface;
                }
            }
            provider->Release(provider);
        }
    }

    return result;
}

void
ui_draw_image(void *image, unsigned int x, unsigned int y) {
   IDirectFBSurface *surface = image;

   if ((image != NULL) && (primary != NULL)) {
       primary->Blit(primary, surface, NULL, x, y);
   }
}

void
ui_unload_image(void *image) {
   IDirectFBSurface *surface = image;

   if (surface) {
       surface->Release(surface);
   }
}

void *
ui_load_font(const char *path, int height) {
    DFBFontDescription dsc;
    IDirectFBFont *result;
    int status;

    if (dfb) {
        dsc.flags  = DFDESC_HEIGHT;
        dsc.height = height;

        status = dfb->CreateFont(dfb, path, &dsc, &result);
        if (status != DFB_OK) result = NULL;
    }
    else result = NULL;

    return result;
}

void
ui_unload_font(void *font) {
   IDirectFBFont *pFont = font;
   if (pFont) pFont->Release(pFont);
}

void
ui_set_font(void *font) {
   IDirectFBFont *pFont = font;
   if (primary) primary->SetFont(primary, pFont);
}

void
ui_set_color(int r, int g, int b, int a) {
   if (primary) primary->SetColor(primary, r, g, b, a);
}

void
ui_draw_string(const char *text, int x, int y, int flags) {
   int align_flags;
   int dfb_flags = 0;

   if (primary) {
      align_flags = (flags & UI_TEXT_ALIGN_FLAGS);
      switch (align_flags) {
         case UI_TEXT_LEFT  : dfb_flags |= DSTF_LEFT;   break;
         case UI_TEXT_CENTER: dfb_flags |= DSTF_CENTER; break;
         case UI_TEXT_RIGHT : dfb_flags |= DSTF_RIGHT;  break;
      }
      primary->DrawString(primary, text, -1, x, y, dfb_flags);
   }
}

void
ui_show_progress(int x, int y, int w, int h) {
   if ((ui_pb_w ==0) && (ui_pb_h == 0)) {
      ui_pb_x = x;
      ui_pb_y = y;
      ui_pb_w = w;
      ui_pb_h = h;
   }
}

static void
ui_clear_progress(void) {
   if ((primary != NULL) && (ui_pb_w > 2) && (ui_pb_h > 0)) {
      primary->SetColor(primary, ui_bg_r, ui_bg_g, ui_bg_b, ui_bg_a);
      primary->FillRectangle(primary, ui_pb_x, ui_pb_y, ui_pb_w, ui_pb_h);
   }
}

static void
ui_draw_progress(void) {
   int w;

   if ((primary != NULL) && (ui_pb_w > 2) && (ui_pb_h > 0)) {
      primary->SetColor(primary, ui_pb_border_r, ui_pb_border_g, ui_pb_border_b, ui_pb_border_a);
      primary->DrawRectangle(primary, ui_pb_x, ui_pb_y, ui_pb_w, ui_pb_h);
      w = (ui_pb_v * (ui_pb_w - 2) / 100);
      primary->SetColor(primary, ui_pb_fill_r, ui_pb_fill_g, ui_pb_fill_b, ui_pb_fill_a);
      primary->FillRectangle(primary, ui_pb_x+1, ui_pb_y+1, w, ui_pb_h-2);
   }
}

void
ui_hide_progress(void) {
   ui_pb_x = 0;
   ui_pb_y = 0;
   ui_pb_w = 0;
   ui_pb_h = 0;
}

void
ui_progress(int percent) {
   if (percent != ui_pb_v) {
      if (percent < ui_pb_v) ui_clear_progress();
      ui_pb_v = percent;
      ui_draw_progress();
   }
}

void
ui_fill_rectangle(int x, int y, int w, int h) {
   if (primary) {
      primary->FillRectangle(primary, x, y, w, h);
   }
}

