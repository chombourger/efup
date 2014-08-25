/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

#include <efup/clist.h>

struct Volume;
typedef struct Volume volume_t;

typedef clist_t volume_list_t;

volume_t *
volume_new(void);

void
volume_destroy(volume_t *vol);

void
volume_list_init(volume_list_t *list);

void
volume_list_destroy(volume_list_t *list);

void
volume_list_add(volume_list_t *list, volume_t *volume);

volume_t *
volume_list_lookup_by_mount_point(volume_list_t *list, const char *mountPoint);

int
volume_list_check_mounted(volume_list_t *list);

const char *
volume_set_spec(volume_t *volume, const char *spec);

const char *
volume_get_spec(volume_t *volume);

const char *
volume_set_mount_point(volume_t *volume, const char *mountPoint);

const char *
volume_get_mount_point(volume_t *volume);

const char *
volume_set_fs_type(volume_t *volume, const char *fsType);

const char *
volume_get_fs_type(volume_t *volume);

int
volume_set_mounted(volume_t *volume, int mounted);

int
volume_get_mounted(volume_t *volume);

