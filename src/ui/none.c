#include <efup/ui.h>
#include <stdio.h>

int ui_width  = 0;
int ui_height = 0;

int
ui_init(int argc, char **argv) {
   return 0;
}

void
ui_destroy(void) {
}

void *
ui_load_image(const char *path, int *pWidth, int *pHeight) {
   if (pWidth) *pWidth   = 0;
   if (pHeight) *pHeight = 0;
   return 0;
}

void
ui_draw_image(void *image, unsigned int x, unsigned int y) {
}

void
ui_unload_image(void *image) {
}

void *
ui_load_font(const char *path, int height) {
   return NULL;
}

void
ui_unload_font(void *font) {
}

void
ui_set_font(void *font) {
}

void
ui_set_color(int r, int g, int b, int a) {
}

void
ui_draw_string(const char *text, int x, int y, int flags) {
}

void
ui_show_progress(int x, int y, int w, int h) {
}

void
ui_hide_progress(void) {
}

void
ui_progress(int percent) {
}

void
ui_fill_rectangle(int x, int y, int w, int h) {
}

