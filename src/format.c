/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/efup.h>

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

static char *mke2fs_paths[] = {
   "/sbin/mke2fs",
   "/system/bin/mke2fs",
   NULL
};

static const char *
mke2fs_path(void) {
    char *result = NULL;
    unsigned int i;
    struct stat s;

    for (i=0; mke2fs_paths[i] != NULL; i++) {
        if (stat(mke2fs_paths[i], &s) == 0) {
            result = mke2fs_paths[i];
            break;
        }
    }

    return result;
}

static int
exec_mke2fs(const char *path, const char *type) {
    int result;
    char *argv[7];
    pid_t pid;
    const char *mke2fs;

    /* Locate mke2fs */
    mke2fs = mke2fs_path();
    if (mke2fs != NULL) {
        argv[0] = (char *) mke2fs;
        argv[1] = "-t";
        argv[2] = (char *) type;
        argv[3] = "-q";
        argv[4] = "-F";
        argv[5] = (char *) path;
        argv[6] = NULL;

        pid = fork();
        if (pid == 0) {
            execv(mke2fs, argv);
            exit(-1);
        }

        waitpid(pid, &result, 0); 
    }
    else result = ENOSYS;

    return result;
}

static int
format_ext2(const char *path) {
    return exec_mke2fs(path, "ext2");
}

static int
format_ext3(const char *path) {
    return exec_mke2fs(path, "ext3");
}

static int
format_ext4(const char *path) {
    return exec_mke2fs(path, "ext4");
}

int
format(const char *vol) {
    const char *fsType, *dev;
    volume_t *volume;
    int result;

    /* Lookup the specified volume. */
    volume = volume_list_lookup_by_mount_point(&volumes, vol);
    if (volume != NULL) {
        /* Check mounted volumes. */
        result = volume_list_check_mounted(&volumes);
        if (result == 0) {
            /* Is the volume mounted? */
            if (volume_get_mounted(volume)) {
                result = EBUSY;
            }
            else {
                /* Get file-system type. */
                fsType = volume_get_fs_type(volume);
                /* Check if supported. */
                if ((strcmp(fsType, "ext2")) &&
                    (strcmp(fsType, "ext3")) &&
                    (strcmp(fsType, "ext4"))) {
                    result = ENOSYS;
                }
            }
        }
    }
    else result = ENOENT;

    /* Volume may be formatted? */
    if (result == 0) {
        dev = volume_get_spec(volume);
        result = ENOSYS;
        if (strcmp(fsType, "ext2") == 0) result = format_ext2(dev);
        if (strcmp(fsType, "ext3") == 0) result = format_ext3(dev);
        if (strcmp(fsType, "ext4") == 0) result = format_ext4(dev);
    }

    return result;
}

