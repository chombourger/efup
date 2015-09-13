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
#include <string.h>
#include <time.h>

#define LOG_FILE "/tmp/efup.log"

#define TOOL(name) extern int name##_main(int, char **);
#include <efup/tools.h>
#undef TOOL

static struct {
    const char *name;
    int (*main)(int, char **);
} tools[] = {
#define TOOL(name) { #name, name##_main },
#include <efup/tools.h>
#undef TOOL
    { NULL, NULL }
};

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
efup_main(int argc, char **argv) {
    time_t start = time(NULL);
    FILE *f = f;
    int error;

    /* Re-direct stdout and stderr to our log file. */
    //f = freopen(LOG_FILE, "a", stdout); setbuf(stdout, NULL);
    //f = freopen(LOG_FILE, "a", stderr); setbuf(stderr, NULL);

    /* Show we are starting up. */
    printf("Starting efup on %s\n", ctime(&start));

    /* Initialize the list of volumes. */
    volume_list_init(&volumes);

    /* Initialize the scripting framework. */
    error = scripting_init();
    if (error) goto destroy_volume_list;

    /* Run the initialization script. */
    error = scripting_load("init.lua");
    if (error) goto destroy_scripting;

    /* Initialize the user interface. */
    error = ui_init(argc, argv);
    if (error) goto destroy_scripting;

    verifier_init("certs.db");
    error = scripting_load("efup.lua");
    verifier_destroy();

    /* We need to destroy the scripting framework before the UI to make sure
     * all UI objects created from scripts are gc'ed. */
    scripting_destroy();

    /* Now destroy the UI framework. */
    ui_destroy();
    goto destroy_volume_list;

destroy_scripting:
    /* Clean-up the scripting environment. */
    scripting_destroy();

destroy_volume_list:
    /* Free the list of volumes. */
    volume_list_destroy(&volumes);

    /* Return status (0=success, >0 for errors). */
    return error;
}

int
init_main(int argc, char **argv) {
   return efup_main(argc, argv);
}

int
main(int argc, char **argv) {
    char *name = argv[0];
    char *cmd;
    int i;

    /* Strip path to get name of the requested tool. */
    cmd = strrchr(argv[0], '/');
    if (cmd) name = cmd + 1;

    /* Lookup requested tool. */
    for (i = 0; tools[i].name; i++) {
        if (!strcmp(tools[i].name, name)) {
            return tools[i].main(argc, argv);
        }
    }

    printf("%s: no such tool\n", name);
    return -1;
}

