/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/efup.h>
#include <efup/fstab.h>
#include <efup/partmgr.h>
#include <efup/scripting.h>
#include <efup/source.h>

#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <string.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/stat.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

/** Lua state/environment. */
static lua_State *state = NULL;

extern int
luaopen_ui(lua_State *L);

#ifdef USE_OPKG
extern int
lua_opkg_open(lua_State *L);
#endif

extern int
strtosize(const char *str, uintmax_t *res);

const static char *PartMgrTypeName = "PartMgrTypeName";

struct PartMgr {
   void *context;
};

static int
lua_extract(lua_State *state) {
    int argc = lua_gettop(state);
    const char *archive, *target;
    int result;

    if (argc == 3) {
        if ((lua_type(state, 2) == LUA_TSTRING) &&
            (lua_type(state, 3) == LUA_TSTRING)) {
            archive = lua_tostring(state, 2);
            target  = lua_tostring(state, 3);
            if (update_source != NULL) {
                result = extract(update_source, archive, target);
            }
            else result = ENOENT;
        }
        else result = EINVAL;
    }
    else result = EINVAL;

    lua_pushnumber(state, result);
    return 1;
}

static int
lua_format(lua_State *state) {
    int argc = lua_gettop(state);
    const char *volume;
    int result;

    if (argc == 2) {
        if (lua_type(state, 2) == LUA_TSTRING) {
            volume = lua_tostring(state, 2);
            result = format(volume);
        }
        else result = EINVAL;
    }
    else result = EINVAL;

    lua_pushnumber(state, result);
    return 1;
}

static int
lua_fstab(lua_State *state) {
    int argc = lua_gettop(state);
    const char *fstab;
    int result;

    if (argc == 2) {
        if (lua_type(state, 2) == LUA_TSTRING) {
            fstab = lua_tostring(state, 2);
            result = fstab_parse(fstab, &volumes);
        }
        else result = EINVAL;
    }
    else result = EINVAL;

    lua_pushnumber(state, result);
    return 1;
}

static int
lua_mdev(lua_State *L) {
   int result;

   result = mdev_s();
   lua_pushnumber(state, result);
   return 1;
}

static int
lua_mount(lua_State *state) {
    int argc = lua_gettop(state);
    const char *volume;
    int result;

    if (argc == 2) {
        if (lua_type(state, 2) == LUA_TSTRING) {
            volume = lua_tostring(state, 2);
            result = efup_mount(volume);
        }
        else result = EINVAL;
    }
    else result = EINVAL;

    lua_pushnumber(state, result);
    return 1;
}

static int
lua_mknod(lua_State *state) {
    int argc = lua_gettop(state);
    const char *name, *type;
    int major, minor;
    mode_t flags = 0666;
    int result = 0;

    if (argc == 5) {
        if ((lua_type(state, 2) == LUA_TSTRING) &&
            (lua_type(state, 3) == LUA_TSTRING) &&
            (lua_type(state, 4) == LUA_TNUMBER) &&
            (lua_type(state, 5) == LUA_TNUMBER)) {

            name  = lua_tostring(state, 2);
            type  = lua_tostring(state, 3);
            major = lua_tonumber(state, 4);
            minor = lua_tonumber(state, 5);

            if (strcmp(type, "b") == 0) flags |= S_IFBLK;
            else if (strcmp(type, "c") == 0) flags |= S_IFCHR;
            else result = EINVAL;
        }
        else result = EINVAL;
    }
    else result = EINVAL;

    if (result == 0) {
        result = mknod(name, flags, makedev(major, minor));
    }

    lua_pushnumber(state, result);
    return 1;
}

static int
lua_run(lua_State *state) {
    int argc = lua_gettop(state);
    const char *script;
    int result;

    if (argc == 2) {
        if (lua_type(state, 2) == LUA_TSTRING) {
            script = lua_tostring(state, 2);
            result = run(update_source, script);
        }
        else result = EINVAL;
    }
    else result = EINVAL;

    lua_pushnumber(state, result);
    return 1;
}

static int
lua_source(lua_State *state) {
    int argc = lua_gettop(state);
    source_t *new_source;
    const char *src;
    int result;

    if (argc == 2) {
        if (lua_type(state, 2) == LUA_TSTRING) {
            src = lua_tostring(state, 2);
            result = source(src, &new_source);
            if (result == 0) {
              /* Switch over to the new source on success. */
              if (update_source != NULL) update_source->destroy(update_source);
              update_source = new_source;
            }
        }
        else result = EINVAL;
    }
    else result = EINVAL;

    lua_pushnumber(state, result);
    return 1;
}

static int
lua_umount(lua_State *state) {
    int argc = lua_gettop(state);
    const char *volume;
    int result;

    if (argc == 2) {
        if (lua_type(state, 2) == LUA_TSTRING) {
            volume = lua_tostring(state, 2);
            result = efup_umount(volume);
        }
        else result = EINVAL;
    }
    else result = EINVAL;

    lua_pushnumber(state, result);
    return 1;
}

static int
lua_verify(lua_State *state) {
    int argc = lua_gettop(state);
    int result;

    if (argc == 1) {
        if (update_source != NULL) {
            result = update_source->verify(update_source);
        }
        else result = EBADF;
    }
    else result = EINVAL;

    lua_pushnumber(state, result);
    return 1;
}

struct PartMgr *
checkPartMgr(lua_State *L, int i) {
   return luaL_checkudata(L, i, PartMgrTypeName);
}

static int
lua_partmgr_new(lua_State *L) {
    struct PartMgr *pPartMgr;
    void *context;
    const char *dev;

    dev = lua_tostring(L, 2);
    context = partmgr_init(dev);
    if (context) {
       pPartMgr = lua_newuserdata(L, sizeof(struct PartMgr));
       pPartMgr->context = context;
       luaL_setmetatable(L, PartMgrTypeName);
       return 1;
    }
    else return 0;
}

static int
lua_partmgr_add(lua_State *L) {
   struct PartMgr *pPartMgr = checkPartMgr(L, 1);
   const char *sizeString, *startString;
   uint64_t start = (uint64_t) -1;
   uint64_t size  = (uint64_t) -1;
   int type, result;

   type        = lua_tonumber(state, 2);
   sizeString  = lua_tostring(L, 3);
   startString = lua_tostring(L, 4);

   if (sizeString) {
      result = strtosize(sizeString, &size);
   }

   if (startString) {
      start = strtoul(startString, NULL, 0);
   }

   result = partmgr_add(pPartMgr->context, type, size, start);
   lua_pushnumber(state, result);
   return 1;
}

static int
lua_partmgr_reset(lua_State *L) {
   struct PartMgr *pPartMgr = checkPartMgr(L, 1);
   int result;

   result = partmgr_reset(pPartMgr->context);
   lua_pushnumber(state, result);
   return 1;
}

static int
lua_partmgr_write(lua_State *L) {
   struct PartMgr *pPartMgr = checkPartMgr(L, 1);
   int result;

   result = partmgr_write(pPartMgr->context);
   lua_pushnumber(state, result);
   return 1;
}

static int
lua_partmgr_gc(lua_State *L) {
   struct PartMgr *pPartMgr = checkPartMgr(L, 1);
   if (pPartMgr) {
      partmgr_destroy(pPartMgr->context);
   }
   return 0;
}

static const struct luaL_Reg efup_funcs [] = {
    { "extract",   lua_extract     },
    { "format",    lua_format      },
    { "fstab",     lua_fstab       },
    { "mdev",      lua_mdev        },
    { "mount",     lua_mount       },
    { "mknod",     lua_mknod       },
    { "partition", lua_partmgr_new },
    { "run",       lua_run         },
    { "source",    lua_source      },
    { "umount",    lua_umount      },
    { "verify",    lua_verify      },
    { NULL,        NULL            }
};

static int
lua_register_funcs(lua_State *state) {

    static const struct luaL_Reg partmgr_lib[] = {
        { "add",   lua_partmgr_add   },
        { "reset", lua_partmgr_reset },
        { "write", lua_partmgr_write },
        { NULL,    NULL              }
    };

    luaL_newlib(state, efup_funcs);

    /* Setup meta data for the "PartMgr" object */
    luaL_newmetatable(state, PartMgrTypeName);
    luaL_newlib(state, partmgr_lib);
    lua_setfield(state, -2, "__index");

    /* GC callback for the "PartMgr" object */
    lua_pushstring(state, "__gc");
    lua_pushcfunction(state, lua_partmgr_gc);
    lua_settable(state, -3);

    /* Remove the PartMgr library object from the stack */
    lua_pop(state, 1);

    return 1;
}

/**
  * Initialize the Lua scripting environment.
  *
  * @return zero on success, an error code otherwise.
  *
  */
int
scripting_init(void) {
    int result;

    state = luaL_newstate();
    if (state != NULL) {
        luaL_openlibs(state);
        luaL_requiref(state, "efup", lua_register_funcs, 1);
        lua_pop(state, 1);
#ifdef USE_OPKG
        luaL_requiref(state, "opkg", lua_opkg_open, 1);
        lua_pop(state, 1);
#endif
        luaL_requiref(state, "ui", luaopen_ui, 1);
        lua_pop(state, 1);
        result = 0;
    }
    else {
        result = ENOMEM;
    }

    return result;
}

/**
  * Destroy (free) the Lua scripting environment.
  *
  */
void
scripting_destroy(void) {

   if (state != NULL) {
       lua_close(state);
       state = NULL;
   }
}

int
scripting_load(const char *file) {
    int result;

    if ((state != NULL) && (file != NULL)) {
        result = luaL_loadfile(state, file);
        if (result == 0) {
            result = lua_pcall(state, 0, 0, 0);
            if (result != LUA_OK) {
                if (result == LUA_ERRSYNTAX) {
                    fprintf(stderr, "%s: syntax error\n", file);
                }
                else {
                    fprintf(stderr, "%s\n", lua_tostring(state, -1));
                }
            }
        }
    }
    else result = EINVAL;

    return result;
}

int
scripting_exec(const char *line) {
    int result;

    if ((state != NULL) && (line != NULL)) {
        result = luaL_loadbuffer(state, line, strlen(line), "line");
        if (result == 0) {
            result = lua_pcall(state, 0, 0, 0);
            if (result != LUA_OK) {
                if (result == LUA_ERRSYNTAX) {
                    fprintf(stderr, "syntax error\n");
                }
                else {
                    fprintf(stderr, "%s\n", lua_tostring(state, -1));
                }
            }
        }
    }
    else result = EINVAL;

    return result;
}

