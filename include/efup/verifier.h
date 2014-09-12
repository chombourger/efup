/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

#include <stddef.h>

int
verifier_init(const char *path);

int
verifier_prepare(void);

int
verifier_feed(void *buffer, size_t size);

int
verifier_finish(void);

void
verifier_destroy(void);

