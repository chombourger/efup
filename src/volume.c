/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/mtab.h>
#include <efup/volume.h>

#include <stdlib.h>
#include <string.h>

struct Volume {
    clist_t listNode;
    char *spec;
    char *mountPoint;
    char *fsType;
    char *mountOptions;
    int mounted;
};

volume_t *
volume_new(void) {
    volume_t *volume;

    volume = (volume_t *) malloc(sizeof(*volume));
    if (volume != NULL) {
        volume->spec = NULL;
        volume->mountPoint = NULL;
        volume->fsType = NULL;
        volume->mountOptions = NULL;
        volume->mounted = 0;
    }

    return volume;
}

void
volume_destroy(volume_t *volume) {

    if (volume != NULL) {
        free(volume->spec);
        free(volume->mountPoint);
        free(volume->fsType);
        free(volume->mountOptions);
        free(volume);
    }
}

void
volume_list_init(volume_list_t *list) {
    CLIST_INIT(list);
}

void
volume_list_destroy(volume_list_t *list) {
    volume_t *current, *next;

    if (list != NULL) {
        current = CLIST_HEAD(list);
        while (!CLIST_END(list, current)) {
            next = CLIST_NEXT(current);
            CLIST_REMOVE(current);
            volume_destroy(current);
            current = next;
        }
    }
}

void
volume_list_add(volume_list_t *list, volume_t *volume) {

    if ((list != NULL) && (volume != NULL)) {
        CLIST_ADDTAIL(list, volume);
    }
}

volume_t *
volume_list_lookup_by_mount_point(volume_list_t *list, const char *mountPoint) {
    volume_t *current, *result;

    result = NULL;
    if ((list != NULL) && (mountPoint != NULL)) {
        current = CLIST_HEAD(list);
        while (!CLIST_END(list, current)) {
            if (strcmp(current->mountPoint, mountPoint) == 0) {
                result = current;
                break;
            }
            current = CLIST_NEXT(current);
        }
    }
    return result;
}

int
volume_list_check_mounted(volume_list_t *list) {
    int result;

    result = mtab_parse("/proc/mounts", list);
    return result;
}

const char *
volume_set_spec(volume_t *volume, const char *spec) {

    if (volume != NULL) {
        free(volume->spec);
        spec = volume->spec = strdup(spec);
    }
    else spec = NULL;

    return spec;
}

const char *
volume_get_spec(volume_t *volume) {
    const char *spec = NULL;

    if (volume != NULL ) {
        spec = volume->spec;
    }

    return spec;
}

const char *
volume_set_mount_point(volume_t *volume, const char *mountPoint) {

    if (volume != NULL) {
        free(volume->mountPoint);
        mountPoint = volume->mountPoint = strdup(mountPoint);
    }
    else mountPoint = NULL;

    return mountPoint;
}

const char *
volume_get_mount_point(volume_t *volume){
    const char *mountPoint = NULL;

    if (volume != NULL ) {
        mountPoint = volume->mountPoint;
    }

    return mountPoint;
}

const char *
volume_set_fs_type(volume_t *volume, const char *fsType) {

    if (volume != NULL) {
        free(volume->fsType);
        fsType = volume->fsType = strdup(fsType);
    }
    else fsType = NULL;

    return fsType;
}

const char *
volume_get_fs_type(volume_t *volume) {
    const char *fsType = NULL;

    if (volume != NULL ) {
        fsType = volume->fsType;
    }

    return fsType;
}

int
volume_set_mounted(volume_t *volume, int mounted) {

    if (volume != NULL) {
        volume->mounted = mounted;
    }
    return mounted;
}

int
volume_get_mounted(volume_t *volume) {
    int mounted = 0;

    if (volume != NULL) {
        mounted = volume->mounted;
    }
    return mounted;
}

