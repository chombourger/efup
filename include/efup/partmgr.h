/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

#include <stdint.h>

void *
partmgr_init(const char *dev);

int
partmgr_reset(void *ctx);

int
partmgr_add(void *ctx, int type, uint64_t size, uint64_t start);

int
partmgr_write(void *ctx);

void
partmgr_destroy(void *ctx);

