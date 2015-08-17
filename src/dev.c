/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/dev.h>

#include <fcntl.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/stat.h>

int
dev_init(void) {

    (void) mknod("/dev/fb0", S_IFCHR|0660, makedev(29,0));
    (void) mknod("/dev/tty0", S_IFCHR|0660, makedev(4,0));
    (void) mknod("/dev/tty1", S_IFCHR|0660, makedev(4,1));
    (void) mknod("/dev/tty2", S_IFCHR|0660, makedev(4,2));
    (void) mknod("/dev/console", S_IFCHR|0660, makedev(5,1));

   return 0;
}

