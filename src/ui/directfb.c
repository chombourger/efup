#include <efup/ui.h>

#include <stdio.h>
#include <unistd.h>
#include <directfb.h>

static IDirectFB *dfb = NULL;
static IDirectFBSurface *primary = NULL;
int ui_width  = 0;
int ui_height = 0;

void __D_init_all(void);
void *ref_d_init_all = __D_init_all;
void directfb_fbdev(void);
void *ref_directfb_fbdev = directfb_fbdev;
void directfbwm_default(void);
void *ref_directfbwm_default = directfbwm_default;
void IDirectFBImageProvider_PNG_ctor(void);
void *ref_idirectfbimageprovider_png = IDirectFBImageProvider_PNG_ctor;

int
ui_init(int argc, char **argv) {
    DFBSurfaceDescription dsc;
    int error;

    error = DirectFBInit(&argc, &argv);
    if (error != DFB_OK) return error;

    error = DirectFBCreate(&dfb);
    if (error != DFB_OK) return error;

    dsc.flags = DSDESC_CAPS;
    dsc.caps  = DSCAPS_PRIMARY | DSCAPS_FLIPPING;

    error = dfb->CreateSurface(dfb, &dsc, &primary);
    if (error != DFB_OK) return error;

    primary->GetSize(primary, &ui_width, &ui_height);
    primary->FillRectangle(primary, 0, 0, ui_width, ui_height);
    primary->Flip(primary, NULL, 0);

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

void
ui_flip_buffers(void) {

    if (primary) {
        primary->Flip(primary, NULL, DSFLIP_WAITFORSYNC);
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

