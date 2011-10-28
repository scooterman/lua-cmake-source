set(files "src/load.c;src/luabins.c;src/luainternals.c;src/save.c")

if(WIN32)
  set(files "${files};luabins.def")
endif(WIN32)

if(${WITH_LUAJIT})
	add_definitions(-DLUAI_BITSINT=32)
else(${WITH_LUAJIT})
	add_definitions(-DLUABINS_LUABUILTASCPP)
endif(${WITH_LUAJIT})

LuaModule(luabins "${files}")

