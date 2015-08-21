/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

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
ui_destroy(void);

