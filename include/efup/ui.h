/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

#define UI_TEXT_LEFT        0
#define UI_TEXT_CENTER      1
#define UI_TEXT_RIGHT       2
#define UI_TEXT_ALIGN_FLAGS 3

extern int ui_width;
extern int ui_height;

int
ui_init(int argc, char **argv);

void
ui_flip_buffers(void);

void *
ui_load_image(const char *path, int *pWidth, int *pHeight);

void
ui_draw_image(void *image, unsigned int x, unsigned int y);

void
ui_unload_image(void *image);

void *
ui_load_font(const char *path, int height);

void
ui_unload_font(void *font);

void
ui_set_font(void *font);

void
ui_set_color(int r, int g, int b, int a);

void
ui_draw_string(const char *text, int x, int y, int flags);

void
ui_show_progress(int x, int y, int w, int h);

void
ui_hide_progress(void);

void
ui_progress(int percent);

void
ui_fill_rectangle(int x, int y, int w, int h);

void
ui_destroy(void);

