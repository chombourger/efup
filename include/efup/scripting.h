/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

int
scripting_init(void);

void
scripting_destroy(void);

int
scripting_load(const char *file);

int
scripting_exec(const char *line);

