# - Try to find the PCRE regular expression library
# Once done this will define
#
#  PCRE_FOUND - system has the PCRE library
#  PCRE_INCLUDE_DIR - the PCRE include directory
#  PCRE_LIBRARIES - The libraries needed to use PCRE

# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (PCRE_INCLUDE_DIR AND PCRE_PCREPOSIX_LIBRARY AND PCRE_PCRE_LIBRARY)
  # Already in cache, be silent
  set(PCRE_FIND_QUIETLY TRUE)
endif (PCRE_INCLUDE_DIR AND PCRE_PCREPOSIX_LIBRARY AND PCRE_PCRE_LIBRARY)


if (NOT WIN32)
  # use pkg-config to get the directories and then use these values
  # in the FIND_PATH() and FIND_LIBRARY() calls
  include(FindPkgConfig)

  pkg_search_module(libpcre _PCREIncDir _PCRELinkDir _PCRELinkFlags _PCRECflags)
endif (NOT WIN32)

find_path(PCRE_INCLUDE_DIR pcre.h PATHS ${_PCREIncDir} PATH_SUFFIXES pcre)

find_library(PCRE_PCRE_LIBRARY NAMES pcre PATHS ${_PCRELinkDir})

if (NOT WIN32)
  find_library(PCRE_PCREPOSIX_LIBRARY NAMES pcreposix PATHS ${_PCRELinkDir})
else (NOT WIN32)
  set(PCRE_PCREPOSIX_LIBRARY ${PCRE_PCRE_LIBRARY})
endif(NOT WIN32)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PCRE DEFAULT_MSG PCRE_INCLUDE_DIR PCRE_PCRE_LIBRARY PCRE_PCREPOSIX_LIBRARY )

set(PCRE_LIBRARIES ${PCRE_PCRE_LIBRARY} ${PCRE_PCREPOSIX_LIBRARY})

mark_as_advanced(PCRE_INCLUDE_DIR PCRE_LIBRARIES PCRE_PCREPOSIX_LIBRARY PCRE_PCRE_LIBRARY)

