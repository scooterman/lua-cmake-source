cmake_minimum_required(VERSION 2.8)
project(luacmake)

# module path
SET(luacmake_CMAKE_DIR "${luacmake_SOURCE_DIR}/etc/cmake")
SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${luacmake_CMAKE_DIR}")

if(${WITH_LUAJIT})
	set(WITH_LUACPP FALSE)
endif(${WITH_LUAJIT})

if(NOT WIN32)
	IF (CMAKE_SIZEOF_VOID_P MATCHES 4)
		set(ENFORCE_32_BIT FALSE)
		set(ENFORCE_64_BIT FALSE)
	ENDIF(CMAKE_SIZEOF_VOID_P MATCHES 4)
	if(${ENFORCE_64_BIT})
		set(ENFORCE_32_BIT FALSE)
	endif(${ENFORCE_64_BIT})
else(NOT WIN32)
	set(ENFORCE_32_BIT FALSE)
	set(ENFORCE_64_BIT FALSE)
endif(NOT WIN32)

# luajit check
if(NOT WIN32)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wunused")
	IF (CMAKE_SIZEOF_VOID_P MATCHES 4)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=i686")
	ENDIF(CMAKE_SIZEOF_VOID_P MATCHES 4)
	if(${WITH_LUAJIT})
		IF (CMAKE_SIZEOF_VOID_P MATCHES 8 AND NOT ${ENFORCE_32_BIT})
			message( FATAL_ERROR " luajit is not supported on x86_64 platform. use 32 chroot in order to build project" )
		ENDIF (CMAKE_SIZEOF_VOID_P MATCHES 8 AND NOT ${ENFORCE_32_BIT})
	endif(${WITH_LUAJIT})
	if(${ENFORCE_32_BIT})
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
		set(CMAKE_LINK_FLAGS "${CMAKE_LINK_FLAGS} -m32")
	endif(${ENFORCE_32_BIT})
	if(${ENFORCE_64_BIT})
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m64")
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m64")
		set(CMAKE_LINK_FLAGS "${CMAKE_LINK_FLAGS} -m64")
	endif(${ENFORCE_64_BIT})
else(NOT WIN32)
	if(${WITH_LUAJIT})
			message( FATAL_ERROR " luajit is not support win32 platform. comment this message and fix cmake scripts" )
	endif(${WITH_LUAJIT})
endif(NOT WIN32)

# default build type
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE RelWithDebInfo)
endif(NOT CMAKE_BUILD_TYPE)

if (${LUA_SET_EXECUTABLE_PATH}) 
	set(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/../bin)
	set(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/../lib)
endif()

if(${WITH_LUAJIT})
	message(STATUS "pcre enabled only on native platform")
else(${WITH_LUAJIT})
	find_package(PCRE REQUIRED)
	include_directories(${PCRE_INCLUDE_DIR})
endif(${WITH_LUAJIT})


if(${WITH_LUAJIT})
	include_directories(${CMAKE_CURRENT_SOURCE_DIR}/libs/luajit/src/)
else(${WITH_LUAJIT})
	include_directories(${CMAKE_CURRENT_SOURCE_DIR}/libs/lua/src/)
endif(${WITH_LUAJIT})


if(${LUA_ADD_DEFAULT_LIBS})
	set(LUA_BUILD_LIBS lpeg lrandom mixlua lua-phpserialize luabins)

	if(${WITH_LUAJIT})
		set(LUA_BUILD_LIBS ${LUA_BUILD_LIBS} lrexlib)
	endif(${WITH_LUAJIT})

endif()

add_subdirectory(libs)
add_subdirectory(src)
