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

static char *mdev_paths[] = {
   "/sbin/mdev",
   NULL
};

static const char *
mdev_path(void) {
    char *result = NULL;
    unsigned int i;
    struct stat s;

    for (i=0; mdev_paths[i] != NULL; i++) {
        if (stat(mdev_paths[i], &s) == 0) {
            result = mdev_paths[i];
            break;
        }
    }

    return result;
}

int
mdev(char **argv) {
    int result;
    pid_t pid;
    const char *mdev_exec;

    /* Locate mdev */
    mdev_exec = mdev_path();
    if (mdev_exec != NULL) {
        argv[0] = (char *) mdev_exec;
        pid = fork();
        if (pid == 0) {
            execv(mdev_exec, argv);
            exit(-1);
        }
        waitpid(pid, &result, 0); 
    }
    else result = ENOSYS;

    return result;
}

int
mdev_s(void) {
   char *argv[3];

   argv[1] = "-s";
   argv[2] = NULL;

   return mdev(argv);
}

