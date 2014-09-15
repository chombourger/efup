/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/mtab.h>

#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>

/**
  * Parse the specified mtab file and flag mounted volumes accordingly.
  *
  * @param path path to the mtab file to be parsed.
  * @param list pointer to the volume list to be updated.
  * @return zero on success, an error code otherwise.
  *
  */
int
mtab_parse(const char *path, volume_list_t *list) {

    FILE *mtab;
    char buf[1024];
    int i, result;
    char *spec, *mountPoint, *fsType, *mountOptions, *freq, *passno;
    volume_t *volume;

    /* Mark volumes at not mounted */
    volume = CLIST_HEAD(list);
    while (!CLIST_END(list, volume)) {
        volume_set_mounted(volume, 0);
        volume = CLIST_NEXT(volume);
    }

    /* Open the specified mtab file. */
    mtab = fopen(path, "r");
    if (mtab != NULL) {
        /* Parse each line. */
        while (fgets(buf, sizeof(buf)-1, mtab)) {
            /* Skip leading spaces. */
            for (i = 0; (buf[i] != '\0') && (isspace(buf[i])); i++);

            /* Ignore comment lines. */
            if ((buf[i] == '\0') || (buf[i] == '#')) continue;

            /* Parse the various fields. */
            spec         = strtok(buf+i, " \t");
            mountPoint   = strtok(NULL, " \t");
            fsType       = strtok(NULL, " \t");
            mountOptions = strtok(NULL, " \t");
            freq         = strtok(NULL, " \t");
            passno       = strtok(NULL, " \t");

            /* Kill warnings about variables set but unused. */
            spec         = spec;
            fsType       = fsType;
            mountOptions = mountOptions;
            freq         = freq;
            passno       = passno;

            /* Allocate and initialize a new volume descriptor. */
            volume = volume_list_lookup_by_mount_point(list, mountPoint);
            if (volume != NULL) {
                volume_set_mounted(volume, 1);
            }
        }
        fclose(mtab);
        result = 0;
    }
    else result = errno;

    return result;
}

