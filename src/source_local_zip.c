/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/source.h>
#include <efup/ui.h>
#include <efup/verifier.h>

#include <archive.h>
#include <archive_entry.h>

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
};

struct source_file {
   struct zip_source *sourcep;
   struct archive *zip;
   struct archive_entry *filep;
};

static const char *source_zip_spec(source_t *sourcep);
static void source_zip_destroy(source_t *sourcep);
static int source_zip_verify(source_t *sourcep);
static uint64_t source_zip_size(source_t *sourcep, const char *path);
static int source_zip_load(source_t *sourcep, const char *path, void **bufferp, size_t *sizep);
static source_file_t *source_zip_open(source_t *sourcep, const char *path, uint64_t *sizep);
static int source_zip_read(source_file_t *filep, void *buf, size_t size);
static void source_zip_close(source_file_t *filep);

static const source_t zip_source_vtable = {
   source_zip_spec,
   source_zip_destroy,
   source_zip_verify,
   source_zip_load,
   source_zip_size,
   source_zip_open,
   source_zip_read,
   source_zip_close
};


static const char *
source_zip_spec(source_t *sourcep) {
   struct zip_source *zip_source = (struct zip_source *) sourcep;
   const char *result;
   if (zip_source != NULL) {
      result = zip_source->path;
   }
   else {
      result = NULL;
   }
   return result;
}

static struct archive *
zip_open(const char *specp) {
   struct archive *zip;
   int result;

   zip = archive_read_new();
   if (zip != NULL) {
      archive_read_support_format_zip(zip);
      result = archive_read_open_filename(zip, specp, 10240);
      if (result != 0) {
         archive_read_free(zip);
         zip = NULL;
      }
   }
   return zip;
}

int
source_local_zip(const char *specp, source_t **sourcep) {
    struct zip_source *zip_source;
    struct archive *zip;
    int result;

    zip = zip_open(specp);
    /* Success? */
    if (zip != NULL) {
        /* Allocate and fill source structure. */
        zip_source = malloc(sizeof(*zip_source));
        if (zip_source != NULL) {
            memcpy(&zip_source->source, &zip_source_vtable, sizeof(zip_source_vtable));
            zip_source->path = strdup(specp);
            if (zip_source->path != NULL) {
                *sourcep = &zip_source->source;
                result = 0;
            }
            else {
                free(zip_source);
                result = ENOMEM;
            }
        }
        else {
            /* Out of memory, close zip and set error code. */
            result = ENOMEM;
        }
        archive_read_free(zip);
    }
    else result = errno;

    return result;
}

static void source_zip_destroy(source_t *sourcep) {
   struct zip_source *zip_source = (struct zip_source *) sourcep;

   if (zip_source != NULL) {
      free((void *)zip_source->path);
      free(zip_source);
   }
}

static int
source_zip_verify(source_t *sourcep) {
   struct zip_source *zip_source = (struct zip_source *) sourcep;
   struct stat st;
   char buffer[1024];
   FILE *filep;
   int n, percent, result;
   unsigned long long bytesRead = 0;

   if (sourcep != NULL) {
      result = stat(zip_source->path, &st);
      if (result == 0) {
         filep = fopen(zip_source->path, "rb");
         if (filep != NULL) {
            result = verifier_prepare();
            if (result == 0) {
               while (result == 0 && !ferror(filep) && !feof(filep)) {
                  n = fread(buffer, 1, sizeof(buffer), filep);
                  if (n > 0) {
                     bytesRead += n;
                     percent = (bytesRead * 100 / st.st_size);
                     ui_progress(percent);
                     result = verifier_feed(buffer, n);
                  }
               }
               if (result == 0) {
                  result = verifier_finish();
               }
            }
            fclose(filep);
         }
         else result = errno;
      }
      else result = errno;
   }
   else result = EBADF;

   return result;
}

static uint64_t
source_zip_size(source_t *sourcep, const char *path) {
   struct zip_source *zip_source = (struct zip_source *) sourcep;
   struct archive *zip;
   struct archive_entry *entry;
   int64_t size = -1;

   if ((sourcep != NULL) && (path != NULL)) {
      zip = zip_open(zip_source->path);
      if (zip != NULL) {
         while (archive_read_next_header(zip, &entry) == ARCHIVE_OK) {
            if (strcmp(archive_entry_pathname(entry), path) == 0) {
               size = archive_entry_size(entry);
            }
         }
         archive_read_free(zip);
      }
   }

   return size;
}
 
static int source_zip_load(source_t *sourcep, const char *path, void **bufferp, size_t *sizep) {
   struct zip_source *zip_source = (struct zip_source *) sourcep;
   char *script_buffer = NULL;
   struct archive *zip;
   struct archive_entry *entry;
   size_t size, read_bytes;
   int result;

   if ((sourcep != NULL) && (path != NULL) && (bufferp != NULL)) {
      zip = zip_open(zip_source->path);
      if (zip != NULL) {
         result = ENOENT;
         while (archive_read_next_header(zip, &entry) == ARCHIVE_OK) {
            if (strcmp(archive_entry_pathname(entry), path) == 0) {
               result = 0;
               size = archive_entry_size(entry);
               if (sizep != NULL) *sizep = size;
               script_buffer = malloc(size + 1);
               if (script_buffer != NULL) {
                  script_buffer[size] = '\0';
                  read_bytes = archive_read_data(zip, script_buffer, size);
                  if ((read_bytes < 0) || (read_bytes != size)) {
                     free(script_buffer);
                     result = EIO;
                  }
                  else if (bufferp != NULL) *bufferp = script_buffer;
               }
               else result = ENOMEM;
               break;
            }
         }
         archive_read_free(zip);
      }
      else result = EBADF;
   }
   else result = EINVAL;

   return result;
}

static source_file_t *
source_zip_open(source_t *sourcep, const char *path, uint64_t *sizep) {
   struct zip_source *zip_source = (struct zip_source *) sourcep;
   source_file_t *file = NULL;
   struct archive *zip;
   struct archive_entry *entry;

   if ((sourcep != NULL) && (path != NULL)) {
      zip = zip_open(zip_source->path);
      if (zip != NULL) {
         while (archive_read_next_header(zip, &entry) == ARCHIVE_OK) {
            if (strcmp(archive_entry_pathname(entry), path) == 0) {
               if (sizep != NULL) *sizep = archive_entry_size(entry);
               file = malloc(sizeof(*file));
               if (file != NULL) {
                  file->sourcep = zip_source;
                  file->zip = zip;
                  file->filep = entry;
                  return file;
               }
               break;
            }
         }
         archive_read_free(zip);
      }
   }
   return NULL;
}

static int
source_zip_read(source_file_t *filep, void *buf, size_t size) {
   int result;

   if (filep != NULL) {
       result = archive_read_data(filep->zip, buf, size);
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
      archive_read_close(filep->zip);
      free(filep);
   } 
}

