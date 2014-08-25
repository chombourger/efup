/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/efup.h>
#include <efup/volume.h>

#include <errno.h>

#include <sys/mount.h>

int
efup_mount(const char *mount_point) {
    volume_t *volumep;
    int result;

    if (mount_point != NULL) {
        volumep = volume_list_lookup_by_mount_point(&volumes, mount_point);
        if (volumep != NULL) {
            result = mount(volume_get_spec(volumep), mount_point,
                volume_get_fs_type(volumep), 0, NULL);
            if (result == -1) result = errno;
        }
        else result = ENOENT;
    }
    else result = EINVAL;

    return result;
}

int
efup_umount(const char *mount_point) {
    volume_t *volumep;
    int result;

    if (mount_point != NULL) {
        volumep = volume_list_lookup_by_mount_point(&volumes, mount_point);
        if (volumep != NULL) {
            result = umount(mount_point);
            if (result == -1) result = errno;
        }
        else result = ENOENT;
    }
    else result = EINVAL;

    return result;
}
 
