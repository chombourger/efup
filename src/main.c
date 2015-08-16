/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/efup.h>
#include <efup/fstab.h>
#include <efup/scripting.h>
#include <efup/ui.h>
#include <efup/verifier.h>
#include <efup/volume.h>

#include <stdio.h>
#include <time.h>

#define LOG_FILE "/tmp/efup.log"

/** List of volumes. */
volume_list_t volumes;

/** Current source. */
source_t *update_source = NULL;

/**
  * efup entry point.
  *
  * @param argc number of arguments
  * @param argv argument values
  * @return zero on success, an error code otherwise.
  *
  */
int
main(int argc, char **argv) {
    time_t start = time(NULL);
    FILE *f = f;
    int error;

    /* Re-direct stdout and stderr to our log file. */
    //f = freopen(LOG_FILE, "a", stdout); setbuf(stdout, NULL);
    //f = freopen(LOG_FILE, "a", stderr); setbuf(stderr, NULL);

    /* Show we are starting up. */
    printf("Starting efup on %s\n", ctime(&start));

    /* Initialize the user interface. */
    error = ui_init(argc, argv);
    if (error) goto end;

    /* Initialize the list of volumes. */
    volume_list_init(&volumes);

    /* Initialize the scripting framework. */
    error = scripting_init();
    if (error) goto destroy_volume_list;

    verifier_init("test.db");
    error = scripting_load("efup.lua");
    verifier_destroy();

    /* Clean-up the scripting environment. */
    scripting_destroy();

destroy_volume_list:
    /* Free the list of volumes. */
    volume_list_destroy(&volumes);

end:
    /* Return status (0=success, >0 for errors). */
    return error;
}

