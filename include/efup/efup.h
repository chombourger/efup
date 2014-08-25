/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

#include <efup/source.h>
#include <efup/volume.h>

extern volume_list_t volumes;
extern source_t *update_source;

int
extract(source_t *sourcep, const char *archive, const char *targetp);

int
format(const char *vol);

int
efup_mount(const char *vol);

int
efup_umount(const char *vol);

int
run(source_t *sourcep, const char *script);

