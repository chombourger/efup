/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/efup.h>
#include <efup/scripting.h>
#include <efup/source.h>

#include <errno.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

static int
lua_opkg_install(lua_State *L) {
   source_t *sourcep;
   const char *specp;
   char **argv;
   int argc, i, result;

   sourcep = update_source;
   if (sourcep != NULL) {
      specp = sourcep->spec(sourcep);
      if (specp != NULL) {
         argc = lua_gettop(L);
         argv = malloc(sizeof(*argv) * (argc + 3));
         if (argv != NULL) {
            argv[1] = "install";
            for (i=2; i<=argc; i++) {
               argv[i] = (char *) lua_tostring(L, i);
            }
            argv[i++] = (char *) specp;
            argv[i++] = NULL;
            result = opkg(argv);
            free(argv);
         }
         else result = ENOMEM;
      }
      else result = EBADF;
   }
   else result = EBADF;

   lua_pushnumber(L, result);
   return 1;
}

int
lua_opkg_open(lua_State *L) {
    
   static const struct luaL_Reg opkg_lib[] = {
      { "Install", lua_opkg_install },
      { NULL,      NULL             }
   };

   /* Create the "opkg" library */
   luaL_newlib(L, opkg_lib);

   return 1;
}

