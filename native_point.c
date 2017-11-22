#define LUA_LIB
#define _GNU_SOURCE

#include <lua.h>
#include <lauxlib.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdbool.h>

typedef struct {
  lua_Number x;
  lua_Number y;
} point_t;

static int point_add(lua_State* L) {
  	point_t* pt1 = (point_t*) lua_topointer(L, -2);
  	point_t* pt2 = (point_t*) lua_topointer(L, -1);
	point_t* new_pt = (point_t*) lua_newuserdata(L, sizeof(point_t));
	//printf("pt1 x y: %f, %f\n", pt1->x, pt1->y);
	//printf("pt2 x y: %f, %f\n", pt2->x, pt2->y);

	new_pt->x = pt1->x + pt2->x;
	new_pt->y = pt1->y + pt2->y;
	//printf("new_pt x y: %f, %f\n", new_pt->x, new_pt->y);
	luaL_getmetatable(L, "point_native");
	lua_setmetatable(L, -2);
  	return 1;
}

static int point_dist(lua_State* L) {
  	point_t* pt1 = (point_t*) lua_topointer(L, -2);
  	point_t* pt2 = (point_t*) lua_topointer(L, -1);
	lua_Number dist = sqrt(pow(pt2->x - pt1->x, 2) + pow(pt2->y - pt1->y, 2));
	lua_pushnumber(L, dist);
	return 1;
}

static int point_eq(lua_State* L) {
  	point_t* pt1 = (point_t*) lua_topointer(L, -2);
  	point_t* pt2 = (point_t*) lua_topointer(L, -1);
	bool eq = (pt2->x == pt1->x) && (pt2->y == pt1->y);
	//printf("equality: %d\n", eq);
	lua_pushboolean(L, eq);
  	return 1;
}


static int point_sub(lua_State* L) {
  	point_t* pt1 = (point_t*) lua_topointer(L, -2);
  	point_t* pt2 = (point_t*) lua_topointer(L, -1);
	point_t* new_pt = (point_t*) lua_newuserdata(L, sizeof(point_t));
	new_pt->x = pt1->x - pt2->x;
	new_pt->y = pt1->y - pt2->y;
	luaL_getmetatable(L, "point_native");
	lua_setmetatable(L, -2);
  	return 1;
}

static int point_x(lua_State* L) {
  	point_t* pt = (point_t*) lua_topointer(L, -1);
	lua_pushnumber(L, pt->x);	
  	return 1;
}

static int point_y(lua_State* L) {
  	point_t* pt = (point_t*) lua_topointer(L, -1);
	lua_pushnumber(L, pt->y);	
  	return 1;
}

static int point_setx(lua_State* L) {
  	point_t* pt = (point_t*) lua_topointer(L, -2);
	lua_Number x = lua_tonumber(L, -1);
	pt->x = x;	
  	return 0;
}

static int point_sety(lua_State* L) {
  	point_t* pt = (point_t*) lua_topointer(L, -2);
	lua_Number y = lua_tonumber(L, -1);
	pt->y = y;	
  	return 0;
}

static int point_new(lua_State* L) {
  	point_t* pt = (point_t*) lua_newuserdata(L, sizeof(point_t));
  	pt->x = lua_tonumber(L, -3);
	pt->y = lua_tonumber(L, -2);
	//printf("x, y = %f, %f\n", pt->x, pt->y);
	luaL_getmetatable(L, "point_native");
	lua_setmetatable(L, -2);
	//int* result = luaL_checkudata(L, -2, "point_native");
	//if(result == NULL){printf("metatable set failure\n");}
	//else{printf("metatable set success\n");}
  	return 1;
}

static int point_tostring(lua_State* L) {
	point_t* pt = (point_t*) lua_topointer(L, -1);
	char str[50];
	sprintf(str, "{%d, %d}", (int)pt->x, (int)pt->y);
	//printf("string: %s\n", str);
	lua_pushstring(L, str);
    return 1;
}

int luaopen_native_point(lua_State* L) {
  // Create the metatable that describes the behaviour of every point object.
  luaL_newmetatable(L, "point_native");

  // Add _, -, =, and tostring metamethods.
  {
    lua_pushstring(L, "__add");
    lua_pushcfunction(L, point_add);
    lua_settable(L, -3);

    lua_pushstring(L, "__sub");
    lua_pushcfunction(L, point_sub);
    lua_settable(L, -3);

    lua_pushstring(L, "__eq");
    lua_pushcfunction(L, point_eq);
    lua_settable(L, -3);

    lua_pushstring(L, "__tostring");
    lua_pushcfunction(L, point_tostring);
    lua_settable(L, -3);
  }

  // Create class table with a new method.
  lua_createtable(L, 1, 0);
  lua_pushstring(L, "new");
  lua_pushcfunction(L, point_new);
  lua_settable(L, -3);

  // Add Dist, X, Y, SetX, and SetY methods to class table.
  {
    lua_pushstring(L, "Dist");
    lua_pushcfunction(L, point_dist);
    lua_settable(L, -3);

    lua_pushstring(L, "X");
    lua_pushcfunction(L, point_x);
    lua_settable(L, -3);

    lua_pushstring(L, "Y");
    lua_pushcfunction(L, point_y);
    lua_settable(L, -3);

    lua_pushstring(L, "SetX");
    lua_pushcfunction(L, point_setx);
    lua_settable(L, -3);

    lua_pushstring(L, "SetY");
    lua_pushcfunction(L, point_sety);
    lua_settable(L, -3);
  }

  // Set the class table to the point metatable's __index.
  lua_pushstring(L, "__index");
  lua_pushvalue(L, -2);
  lua_settable(L, -4);

  // Only return one value at the top of the stack, which is the Point class
  // table.
  return 1;
}
