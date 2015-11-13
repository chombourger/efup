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

static char *opkg_paths[] = {
   "./opkg",
   "/sbin/opkg",
   NULL
};

static const char *
opkg_path(void) {
    char *result = NULL;
    unsigned int i;
    struct stat s;

    for (i=0; opkg_paths[i] != NULL; i++) {
        if (stat(opkg_paths[i], &s) == 0) {
            result = opkg_paths[i];
            break;
        }
    }

    return result;
}

int
opkg(char **argv) {
    int result;
    pid_t pid;
    const char *opkg_exec;

    /* Locate opkg */
    opkg_exec = opkg_path();
    if (opkg_exec != NULL) {
        argv[0] = (char *) opkg_exec;
        pid = fork();
        if (pid == 0) {
            execv(opkg_exec, argv);
            exit(-1);
        }
        waitpid(pid, &result, 0); 
    }
    else result = ENOSYS;

    return result;
}

