#include <efup/ui.h>

#include <stdio.h>
#include <unistd.h>
#include <directfb.h>

static IDirectFB *dfb = NULL;
static IDirectFBSurface *primary = NULL;
static int screen_width  = 0;
static int screen_height = 0;

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

    primary->GetSize(primary, &screen_width, &screen_height);
    primary->FillRectangle(primary, 0, 0, screen_width, screen_height);

    primary->SetColor(primary, 0x80, 0x80, 0xff, 0xff);
    primary->DrawLine(primary, 0, screen_height / 2, screen_width - 1, screen_height / 2);
    primary->Flip(primary, NULL, 0);

    sleep(5);

    primary->Release(primary);
    dfb->Release(dfb);

    return 0;
}
