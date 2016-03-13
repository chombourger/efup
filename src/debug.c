/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/debug.h>
#include <stdarg.h>
#include <stdio.h>

int
efup_debug(const char *fmt, ...) {
   va_list args;
   int result;

   va_start(args, fmt);
   result = vfprintf(stderr, fmt, args);
   fprintf(stderr, "\n");
   va_end(args);

   return result;
}

