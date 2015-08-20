/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/efup.h>
#include <efup/fstab.h>
#include <efup/scripting.h>
#include <efup/source.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <errno.h>
#include <string.h>

/** Lua state/environment. */
static lua_State *state = NULL;

extern int
luaopen_ui(lua_State *L);

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

    printf("format> %d\n", result);
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

static const struct luaL_Reg efup_funcs [] = {
    { "extract", lua_extract },
    { "format",  lua_format  },
    { "fstab",   lua_fstab   },
    { "mount",   lua_mount   },
    { "run",     lua_run     },
    { "source",  lua_source  },
    { "umount",  lua_umount  },
    { "verify",  lua_verify  },
    { NULL,      NULL        }
};

static int
lua_register_funcs(lua_State *state) {
    luaL_newlib(state, efup_funcs);
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
printf("pcall: %d\n", result);
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
printf("### pcall %d\n", result);
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

