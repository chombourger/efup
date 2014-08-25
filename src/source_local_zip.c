/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/source.h>
#include <efup/verifier.h>
#include "external/libzip/lib/zip.h"

#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/stat.h>

struct zip_source {
    source_t source;
    const char *path;
    struct zip *zip;
};

struct source_file {
    struct zip_source *sourcep;
    struct zip_file *filep;
};

static void source_zip_destroy(source_t *sourcep);
static int source_zip_verify(source_t *sourcep);
static int source_zip_load(source_t *sourcep, const char *path, void **bufferp, size_t *sizep);
static source_file_t *source_zip_open(source_t *sourcep, const char *path);
static int source_zip_read(source_file_t *filep, void *buf, size_t size);
static void source_zip_close(source_file_t *filep);

static const source_t zip_source_vtable = {
    source_zip_destroy,
    source_zip_verify,
    source_zip_load,
    source_zip_open,
    source_zip_read,
    source_zip_close
};

int
source_local_zip(const char *specp, source_t **sourcep) {
    struct zip_source *zip_source;
    struct zip *zip;
    int result;

    /* Parse the opened zip file. */
    zip = zip_open(specp, 0, &result);
    if (zip != NULL) {
        /* Success, allocate and fill source structure. */
        zip_source = malloc(sizeof(*zip_source));
        if (zip_source != NULL) {
            memcpy(&zip_source->source, &zip_source_vtable, sizeof(zip_source_vtable));
            zip_source->path  = strdup(specp);
            zip_source->zip   = zip;
            if (zip_source->path != NULL) {
                *sourcep = &zip_source->source;
                result = 0;
            }
            else {
                zip_close(zip);
                free(zip_source);
                result = ENOMEM;
            }
        }
        else {
            /* Out of memory, close zip and set error code. */
            zip_close(zip);
            result = ENOMEM;
        }
    }

    return result;
}

static void source_zip_destroy(source_t *sourcep) {
    struct zip_source *zip_source = (struct zip_source *) sourcep;

    if (zip_source != NULL) {
        zip_close(zip_source->zip);
        free(zip_source);
    }
}

static int
source_zip_verify(source_t *sourcep) {
    struct zip_source *zip_source = (struct zip_source *) sourcep;
    char buffer[1024];
    FILE *filep;
    int n, result;

    if (sourcep != NULL) {
        filep = fopen(zip_source->path, "rb");
        if (filep != NULL) {
            result = verifier_prepare();
            if (result == 0) {
                while (result == 0 && !ferror(filep) && !feof(filep)) {
                    n = fread(buffer, 1, sizeof(buffer), filep);
                    if (n > 0) {
                        result = verifier_feed(buffer, n);
                    }
                }
                if (result == 0) {
                    result = verifier_finish();
                }        
            }
            fclose(filep);
        }
    }
    else result = EBADF;

    return result;
}

static int source_zip_load(source_t *sourcep, const char *path, void **bufferp, size_t *sizep) {
    struct zip_source *zip_source = (struct zip_source *) sourcep;
    char *script_buffer = NULL, *read_buffer;
    struct zip_file *zipf;
    struct zip_stat zips;
    int result;

    if ((sourcep != NULL) && (path != NULL) && (bufferp != NULL)) {
        result = zip_stat(zip_source->zip, path, ZIP_FL_UNCHANGED, &zips);
        if (result == 0) {
            script_buffer = malloc(zips.size + 1);
            if (script_buffer != NULL) {
                script_buffer[zips.size] = '\0';
                zipf = zip_fopen_index(zip_source->zip, zips.index, ZIP_FL_UNCHANGED);
                if (zipf != NULL) {
                    zip_uint64_t remaining = zips.size;
                    read_buffer = script_buffer;
                    while (remaining > 0) {
                        int n = zip_fread(zipf, read_buffer, 1024);
                        if (n >= 0) {
                            remaining -= n;
                            read_buffer += n;
                        }
                    }
                    zip_fclose(zipf);
                    *bufferp = script_buffer;
                    if (sizep != NULL) *sizep = zips.size;
                }
                else zip_error_get(zip_source->zip, &result, NULL);
            }
            else result = ENOMEM;
        }
        else zip_error_get(zip_source->zip, &result, NULL);
    }
    else result = EINVAL;

    return result;
}

static source_file_t *
source_zip_open(source_t *sourcep, const char *path) {
    struct zip_source *zip_source = (struct zip_source *) sourcep;
    struct zip_file *zipf;
    struct source_file *file = NULL;

    if ((sourcep != NULL) && (path != NULL)) {
        zipf = zip_fopen(zip_source->zip, path, ZIP_FL_UNCHANGED);
        if (zipf != NULL) {
            file = malloc(sizeof(*file));
            if (file != NULL) {
                file->sourcep = zip_source;
                file->filep = zipf;
            }
        }
    }

    return file; 
}

static int
source_zip_read(source_file_t *filep, void *buf, size_t size) {
   int result;

   if (filep != NULL) {
       result = zip_fread(filep->filep, buf, size);
       if (result == -1) {
           errno = EIO;
       }
   }
   else {
       result = -1;
       errno  = EBADF;
   }

   return result;
}

static void
source_zip_close(source_file_t *filep) {
    if (filep != NULL) {
        zip_fclose(filep->filep);
        free(filep);
    }
}

