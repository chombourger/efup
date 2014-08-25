/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/source.h>

#include <errno.h>
#include <stdio.h>
#include <string.h>

int
source(const char *specp, source_t **sourcep) {
    source_type_t type = SOURCE_LOCAL_FOLDER;
    size_t len;
    int result;

    if ((specp == NULL) || (sourcep == NULL)) return EINVAL;

    if (strncmp(specp, "file://", 7) == 0) specp += 7;
    len = strlen(specp);

    /* Zip file source? */
    if ((type == SOURCE_LOCAL_FOLDER) && (len >= 4) &&
        (strcmp(specp+len-4, ".zip") == 0)) {
        type = SOURCE_LOCAL_ZIP;
    }

    /* Default result to source not supported (ENOSYS) */
    result = ENOSYS;

    /* Setup specified source */
    switch (type) {
        case SOURCE_LOCAL_FOLDER:
            result = source_local_folder(specp, sourcep);
            break;
        case SOURCE_LOCAL_ZIP:
            result = source_local_zip(specp, sourcep);
            break;
    }

    return result;
}

