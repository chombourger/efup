/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

#include <stdlib.h>

struct source;
typedef struct source source_t;

struct source_file;
typedef struct source_file source_file_t;

struct source {
    void (* destroy)(source_t *sourcep);
    int (* verify)(source_t *sourcep);
    int  (* load)(source_t *sourcep, const char *path, void **bufferp, size_t *sizep);
    source_file_t *(* open)(source_t *sourcep, const char *path);
    int (* read)(source_file_t *filep, void *buf, size_t size);
    void (* close)(source_file_t *filep);
};

typedef enum {
    SOURCE_LOCAL_FOLDER,
    SOURCE_LOCAL_ZIP
} source_type_t;

int
source(const char *specp, source_t **sourcep);

int
source_local_folder(const char *specp, source_t **sourcep);

int
source_local_zip(const char *specp, source_t **sourcep);

