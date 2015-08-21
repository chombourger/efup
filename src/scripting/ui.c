/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/efup.h>
#include <efup/scripting.h>
#include <efup/ui.h>

#include <errno.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

/** Lua state/environment. */
static lua_State *state = NULL;

struct Font {
   void *data;
};

struct Image {
   void *data;
   int width;
   int height;
};

const static char *FontTypeName  = "FontTypeName";
const static char *ImageTypeName = "ImageTypeName";

struct Font *
checkFont(lua_State *L, int i) {
    struct Font *pFont;

    pFont = luaL_checkudata(L, i, FontTypeName);
    return pFont;
}

struct Image *
checkImage(lua_State *L, int i) {
    struct Image *pImage;

    pImage = luaL_checkudata(L, i, ImageTypeName);
    return pImage;
}

static int
lua_ui_font(lua_State *L) {
    struct Font *pFont;
    void *pFontData;
    const char *path;
    int height;

    path = lua_tostring(L, 2);
    height = lua_tonumber(L, 3);

    pFontData = ui_load_font(path, height);

    pFont = lua_newuserdata(L, sizeof(struct Font));
    pFont->data = pFontData;
    luaL_setmetatable(L, FontTypeName);

    return 1;
}

static int
lua_ui_image(lua_State *L) {
    struct Image *pImage;
    void *pImageData;
    const char *path;
    int width, height;

    path = lua_tostring(L, 2);
    pImageData = ui_load_image(path, &width, &height);

    pImage = lua_newuserdata(L, sizeof(struct Image));
    pImage->data = pImageData;
    pImage->width = width;
    pImage->height = height;
    luaL_setmetatable(L, ImageTypeName);

    return 1;
}

static int
lua_ui_flip_buffers(lua_State *L) {
    ui_flip_buffers();
    return 0;
}

static int
lua_ui_width(lua_State *L) {
    lua_pushnumber(state, ui_width);
    return 1;
}

static int
lua_ui_height(lua_State *L) {
    lua_pushnumber(state, ui_height);
    return 1;
}

static int
lua_font_gc(lua_State *L) {
    struct Font *pFont = checkFont(L, 1);
    if (pFont) {
        ui_unload_font(pFont->data);
    }
    return 0;
}

static int
lua_ui_set_font(lua_State *L) {
   struct Font *pFont = checkFont(L, 2);
   if (pFont) ui_set_font(pFont->data);
    return 0;
}

static int
lua_image_gc(lua_State *L) {
    struct Image *pImage = checkImage(L, 1);
    if (pImage) {
        ui_unload_image(pImage->data);
    }
    return 0;
}

int
lua_image_draw(lua_State *L) {
    struct Image *pImage = checkImage(L, 1);
    int argc = lua_gettop(state);
    int x, y;
    int result;

    if (argc == 3) {
        if ((lua_type(state, 2) == LUA_TNUMBER) &&
            (lua_type(state, 3) == LUA_TNUMBER)) {
            x = lua_tonumber(state, 2);
            y = lua_tonumber(state, 3);
            ui_draw_image(pImage->data, x, y);
            result = 0;
        }
        else result = EINVAL;
    }
    else result = EINVAL;

    lua_pushnumber(state, result);
    return 1;
}

static int
lua_image_width(lua_State *L) {
    struct Image *pImage;
    int width = 0;

    pImage = checkImage(L, 1);
    if (pImage) width = pImage->width;

    lua_pushnumber(state, width);
    return 1;
}

static int
lua_image_height(lua_State *L) {
    struct Image *pImage;
    int height = 0;

    pImage = checkImage(L, 1);
    if (pImage) height = pImage->height;

    lua_pushnumber(state, height);
    return 1;
}

static int
lua_ui_set_color(lua_State *L) {
   int r, g, b, a;

   r = lua_tonumber(L, 2);
   g = lua_tonumber(L, 3);
   b = lua_tonumber(L, 4);
   a = lua_tonumber(L, 5);

   ui_set_color(r, g, b, a);
   return 0;
}

static int
lua_ui_draw_string(lua_State *L) {
   const char *text;
   int x, y, flags;

   text  = lua_tostring(L, 2);
   x     = lua_tonumber(L, 3);
   y     = lua_tonumber(L, 4);
   flags = lua_tonumber(L, 5);

   ui_draw_string(text, x, y, flags);
   return 0;
}

int
luaopen_ui(lua_State *L) {
    static const struct luaL_Reg font_lib[] = {
        { NULL,     NULL             }
    };

    static const struct luaL_Reg image_lib[] = {
        { "Draw",   lua_image_draw   },
        { "Height", lua_image_height },
        { "Width",  lua_image_width  },
        { NULL,     NULL             }
    };
    
    static const struct luaL_Reg ui_lib[] = {
        { "DrawString",  lua_ui_draw_string  },
        { "FlipBuffers", lua_ui_flip_buffers },
        { "Font",        lua_ui_font         },
        { "Height",      lua_ui_height       },
        { "Image",       lua_ui_image        },
        { "SetColor",    lua_ui_set_color    },
        { "SetFont",     lua_ui_set_font     },
        { "Width",       lua_ui_width        },
        { NULL,          NULL                }
    };

    state = L;

    /* Create the "ui" library */
    luaL_newlib(L, ui_lib);

    /* Add constants to the UI object */
    lua_pushnumber(L, UI_TEXT_LEFT);
    lua_setfield(L, -2, "TEXT_LEFT");
    lua_pushnumber(L, UI_TEXT_CENTER);
    lua_setfield(L, -2, "TEXT_CENTER");
    lua_pushnumber(L, UI_TEXT_RIGHT);
    lua_setfield(L, -2, "TEXT_RIGHT");

    /* Setup meta data for the "Font" object */
    luaL_newmetatable(L, FontTypeName);
    luaL_newlib(L, font_lib);
    lua_setfield(L, -2, "__index");

    /* GC callback for the "Font" object */
    lua_pushstring(L, "__gc");
    lua_pushcfunction(L, lua_font_gc);
    lua_settable(L, -3);

    /* Remove the Font library object from the stack */
    lua_pop(L, 1);

    /* Setup meta data for the "Image" object */
    luaL_newmetatable(L, ImageTypeName);
    luaL_newlib(L, image_lib);
    lua_setfield(L, -2, "__index");
 
    /* GC callback for the "Image" object */
    lua_pushstring(L, "__gc");
    lua_pushcfunction(L, lua_image_gc);
    lua_settable(L, -3);

    /* Remove the Image library object from the stack */
    lua_pop(L, 1);

    return 1;
}

