/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/debug.h>
#include <efup/partmgr.h>

#include <libfdisk.h>

#include <errno.h>
#include <string.h>

void *
partmgr_init(const char *dev) {
   struct fdisk_context *context;
   int result;

   fdisk_init_debug(0);
   context = fdisk_new_context();

   if (context) {
      result = fdisk_assign_device(context, dev, 0);
      if (result != 0) {
         EFUP_DEBUG("fdisk_assign_device(%s) failed (%d)!", dev, result);
         fdisk_unref_context(context);
         context = NULL;
      }
      else {
         if (!fdisk_has_label(context)) {
            /* Device does not contain a recognized partition table */
            fdisk_create_disklabel(context, NULL);
         }
      }
   }
   else {
      EFUP_DEBUG("fdisk_new_context failed!");
   }

   return context;
}

int
partmgr_reset(void *ctx) {
   struct fdisk_context *context = ctx;
   struct fdisk_label *label;
   int result;

   if (ctx) {
      result = fdisk_create_disklabel(context, "dos");
      if (result == 0) {
         result = fdisk_reset_alignment(context);
         if (result == 0) {
            label = fdisk_get_label(context, "dos");
            result = fdisk_dos_enable_compatible(label, 0);
            if (result != 0) {
               EFUP_DEBUG("fdisk_dos_enable_compatible failed (%d)", result);
            }
         }
         else {
            EFUP_DEBUG("fdisk_reset_alignment failed (%d)", result);
         }
      }
      else {
         EFUP_DEBUG("fdisk_create_disklabel(\"dos\") failed (%d)!", result);
      }
   }
   else {
      EFUP_DEBUG("partmgr_reset called without context!");
      result = EBADF;
   }

   return result;
}

static int
ask_cb (struct fdisk_context *context, struct fdisk_ask *ask, void *data) {
   const char *query;
   int def;

   query = fdisk_ask_get_query(ask);
   if (query != NULL) {
      if (strcmp(query, "Partition type") == 0) {
         def = fdisk_ask_menu_get_default(ask);
         fdisk_ask_menu_set_result(ask, def);
         return 0;
      }
   }
   return 0;
}

int
partmgr_add(void *ctx, int code, uint64_t size, uint64_t start) {
   struct fdisk_context *context = ctx;
   struct fdisk_partition *part;
   struct fdisk_parttype *type;
   size_t partno;
   int result;

   if (context) {
      part = fdisk_new_partition();
      if (part) {
         fdisk_reset_partition(part);
         (void) fdisk_partition_size_explicit(part, 0);
         type = fdisk_new_parttype();
         if (type) {
            (void) fdisk_parttype_set_code(type, code);
            (void) fdisk_partition_set_type(part, type);
            (void) fdisk_partition_partno_follow_default(part, 1);

            /* Start offset */
            if (start != (uint64_t) -1) {
               (void) fdisk_partition_set_start(part, start);
            }
            else {
               (void) fdisk_partition_start_follow_default(part, 1);
            }

            /* Partition size */
            if (size != (uint64_t) -1) {
               (void) fdisk_partition_set_size(part, size / fdisk_get_sector_size(context));
            }
            else {
               (void) fdisk_partition_end_follow_default(part, 1);
            }

            /* Add specified partition */
            fdisk_set_ask(context, ask_cb, NULL);
            result = fdisk_add_partition(context, part, &partno);
            fdisk_set_ask(context, NULL, NULL);
            fdisk_unref_parttype(type);
         }
         else result = ENOMEM;
         fdisk_unref_partition(part);
      }
      else result = ENOMEM;
   }
   else result = EBADF;

   return result;
}

int
partmgr_write(void *ctx) {
   struct fdisk_context *context = ctx;
   int result;

   if (context) {
      result = fdisk_write_disklabel(context);
      if (result == 0) {
         result = fdisk_reread_partition_table(context);
      }
   }
   else result = EBADF;

   return result;
}

void
partmgr_destroy(void *ctx) {
   struct fdisk_context *context = ctx;

   if (context) {
      fdisk_unref_context(context);
   }
}

