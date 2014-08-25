/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/efup.h>
#include <efup/scripting.h>

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int
run(source_t *sourcep, const char *script) {
    void *script_buffer = NULL;
    int result;

    if (sourcep != NULL) {
        result = sourcep->load(sourcep, script, &script_buffer, NULL);
        if ((result == 0) && (script_buffer != NULL)) {
            result = scripting_exec(script_buffer);
            free(script_buffer);
        }
    }
    else result = ENOENT;

    return result;
}

