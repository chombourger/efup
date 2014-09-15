/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/fstab.h>

#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>

/**
  * Parse the specified fstab file and populate the provided volume list.
  *
  * @param path path to the fstab file to be parsed.
  * @param list pointer to the volume list to be populated.
  * @return zero on success, an error code otherwise.
  *
  */
int
fstab_parse(const char *path, volume_list_t *list) {

    FILE *fstab;
    char buf[1024];
    int i, result;
    char *spec, *mountPoint, *fsType, *mountOptions, *freq, *passno;
    volume_t *volume;

    /* Open the specified fstab file. */
    fstab = fopen(path, "r");
    if (fstab != NULL) {
        /* Parse each line. */
        while (fgets(buf, sizeof(buf)-1, fstab)) {
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
            mountOptions = mountOptions;
            freq         = freq;
            passno       = passno;

            /* Allocate and initialize a new volume descriptor. */
            volume = volume_new();
            if (volume != NULL) {
                volume_set_spec(volume, spec);
                volume_set_mount_point(volume, mountPoint);
                volume_set_fs_type(volume, fsType);
                /* Add the created volume descriptor to the volume list. */
                volume_list_add(list, volume);
            }
        }
        fclose(fstab);
        result = 0;
    }
    else result = ENOENT;

    return result;
}

