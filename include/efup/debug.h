/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

extern int
efup_debug(const char *fmt, ...);

#if EFUP_BUILD_DEBUGS

#define EFUP_DEBUG(fmt,...) do { efup_debug(fmt, ##__VA_ARGS__); } while(0)

#endif /* EFUP_BUILD_DEBUGS */

#ifndef EFUP_DEBUG
#define EFUP_DEBUG(fmt,...) do { } while(0)
#endif

