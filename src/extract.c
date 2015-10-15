/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/efup.h>
#include <efup/ui.h>

#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

typedef enum {
    ARC_UNKNOWN,
    ARC_TAR,
    ARC_TAR_BZ2,
    ARC_TAR_GZ
} arc_type_t;

static char *tar_paths[] = {
   "/bin/tar",
   NULL
};

static const char *
tar_path(void) {
    char *result = NULL;
    unsigned int i;
    struct stat s;

    for (i=0; tar_paths[i] != NULL; i++) {
        if (stat(tar_paths[i], &s) == 0) {
            result = tar_paths[i];
            break;
        }
    }

    return result;
}

static int
do_extract(arc_type_t type, source_t *sourcep, source_file_t *filep, unsigned long long bytesTotal, const char *targetp) {
    int pipe_fds[2];
    pid_t pid;
    char buffer[1024];
    char *argv[6];
    const char *tar;
    int n, result;
    unsigned long long bytesRead = 0;
    int percent;

    /* Create the pipe to feed the unarchiver process (e.g. tar). */
    result = pipe(pipe_fds);
    if (result == 0) {
        pid = fork();
        if (pid == -1) {
            /* Failed to fork */
            result = errno;
            close(pipe_fds[1]);
            close(pipe_fds[0]);
        }
        else if (pid == 0) {
            /* Child */
            signal(SIGPIPE, SIG_DFL);
            result = dup2(pipe_fds[0], fileno(stdin));
            close(pipe_fds[0]);
            close(pipe_fds[1]);
            if (result == 0) {
                switch (type) {
                    case ARC_UNKNOWN:
                        result = ENOSYS;
                        break;
                    case ARC_TAR:
                        tar = tar_path();
                        if (tar != NULL) {
                            argv[0] = (char *) tar;
                            argv[1] = "-xf";
                            argv[2] = "-";
                            argv[3] = "-C";
                            argv[4] = (char *) targetp;
                            argv[5] = NULL;
                            result = execv(tar, argv);
                            if (result == -1) result = errno;
                        }
                        else result = ENOENT;
                        break;
                    case ARC_TAR_BZ2:
                        tar = tar_path();
                        if (tar != NULL) {
                            argv[0] = (char *) tar;
                            argv[1] = "-jxf";
                            argv[2] = "-";
                            argv[3] = "-C";
                            argv[4] = (char *) targetp;
                            argv[5] = NULL;
                            result = execv(tar, argv);
                            if (result == -1) result = errno;
                        }
                        else result = ENOENT;
                        break;
                    case ARC_TAR_GZ:
                        tar = tar_path();
                        if (tar != NULL) {
                            argv[0] = (char *) tar;
                            argv[1] = "-zxf";
                            argv[2] = "-";
                            argv[3] = "-C";
                            argv[4] = (char *) targetp;
                            argv[5] = NULL;
                            result = execv(tar, argv);
                            if (result == -1) result = errno;
                        }
                        else result = ENOENT;
                        break;
                }
            }
            else result = errno;
            exit(result);
        }
        else {
            /* Parent */
            close(pipe_fds[0]);
            do {
                n = sourcep->read(filep, buffer, sizeof(buffer));
                if (n > 0) {
                    bytesRead += n;
                    percent = (bytesRead * 100 / bytesTotal);
                    ui_progress(percent);
                    result = write(pipe_fds[1], buffer, n);
                    if (result == -1) {
                        result = errno;
                        fprintf(stderr, "failed to write to process %u (%d)\n", pid, result);
                        n = -1;
                    }
                    else if (result != n) {
                        fprintf(stderr, "%d bytes sent to process %u, expected %d\n", result, pid, n);
                    }
                }
                else result = EIO;
            } while (n > 0);
            /* close pipe */
            close(pipe_fds[1]);
            /* wait for child process to exit */
            waitpid(pid, &result, 0);
        }
    }
    else result = errno;

    return result;
}

int
extract(source_t *sourcep, const char *archive, const char *targetp) {
    source_file_t *filep;
    arc_type_t type = ARC_UNKNOWN;
    struct stat target_stat;
    unsigned long long bytesTotal;
    size_t len;
    int result;

    if ((sourcep != NULL) && (archive != NULL) && (targetp != NULL)) {
        len = strlen(archive);

        /* Check for supported archives. */
        if ((len >= 4) && (strcmp(archive+len-4, ".tar") == 0)) type = ARC_TAR;
        else if ((len >= 8) && (strcmp(archive+len-8, ".tar.bz2") == 0)) type = ARC_TAR_BZ2;
        else if ((len >= 7) && (strcmp(archive+len-7, ".tar.gz") == 0)) type = ARC_TAR_GZ;

        /* Supported archive? */
        if (type != ARC_UNKNOWN) {
            /* Check target */
            result = stat(targetp, &target_stat);
            if (result == -1) result = errno;
            else if (!S_ISDIR(target_stat.st_mode)) result = ENOTDIR;

            /* Get archive size */
            bytesTotal = sourcep->size(sourcep, archive);

            /* Open source */
            filep = sourcep->open(sourcep, archive);
            if (filep != NULL) {
                /* Do the actual extract */
                result = do_extract(type, sourcep, filep, bytesTotal, targetp);
            }
            else result = EIO;
        }
        else result = ENOSYS;
    }
    else result = EINVAL;

    return result;
}

