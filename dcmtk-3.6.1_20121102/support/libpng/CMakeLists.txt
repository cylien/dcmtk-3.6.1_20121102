#----------------------------------------------------------------------------
# CMake file for libpng. See root CMakeLists.txt
#----------------------------------------------------------------------------
PROJECT(libpng C)

#-----------------------------------------------------------------------------
# Platform-specific settings
#-----------------------------------------------------------------------------
INCLUDE(${CMAKE_MODULE_PATH}/dcmtkMacros.cmake)
IF(NOT WIN32)
  FIND_LIBRARY(M_LIBRARY NAMES m PATHS /usr/lib /usr/local/lib)
  IF(NOT M_LIBRARY)
    MESSAGE(STATUS "math library 'libm' not found - floating point support disabled")
  ENDIF()
ELSE()
  # not needed on windows
  SET(M_LIBRARY "")
ENDIF()

# Some needed to define
ADD_DEFINITIONS(-DPNG_CONFIGURE_LIBPNG)
IF(BUILD_SHARED_LIBS)
  ADD_DEFINITIONS(-DPNG_BUILD_DLL )
ENDIF(BUILD_SHARED_LIBS)
ENABLE_TESTING()
#-----------------------------------------------------------------------------
# Configuation for header files
#-----------------------------------------------------------------------------
# Use the prebuilt pnglibconf.h file from the scripts folder
# TODO: fix this by building with awk; without this no cmake build can be
# configured directly (to do so indirectly use your local awk to build a
# pnglibconf.h in the build directory.)
CONFIGURE_FILE(${WITH_LIBPNGINC}/scripts/pnglibconf.h.prebuilt
               ${CMAKE_CURRENT_BINARY_DIR}/${PNG_LIBRARY}/pnglibconf.h)              
INCLUDE_DIRECTORIES(${WITH_LIBPNGINC}
  ${CMAKE_CURRENT_BINARY_DIR}/${PNG_LIBRARY} 
  ${WITH_ZLIBINC}
  ${CMAKE_BINARY_DIR}/${3RDLIB_FOLDER_NAME}/${ZLIB_LIBRARY}/${ZLIB_LIBRARY})

#-----------------------------------------------------------------------------
# libpng
#-----------------------------------------------------------------------------
set(LIBPNG_PUBLIC_HDRS
  ${WITH_LIBPNGINC}/png.h
  ${WITH_LIBPNGINC}/pngconf.h
  ${CMAKE_CURRENT_BINARY_DIR}/${PNG_LIBRARY}/pnglibconf.h
)
set(LIBPNG_SOURCES
  ${WITH_LIBPNGINC}/pngdebug.h
  ${WITH_LIBPNGINC}/pnginfo.h
  ${WITH_LIBPNGINC}/pngpriv.h
  ${WITH_LIBPNGINC}/pngstruct.h
  ${WITH_LIBPNGINC}/png.c
  ${WITH_LIBPNGINC}/pngerror.c
  ${WITH_LIBPNGINC}/pngget.c
  ${WITH_LIBPNGINC}/pngmem.c
  ${WITH_LIBPNGINC}/pngpread.c
  ${WITH_LIBPNGINC}/pngread.c
  ${WITH_LIBPNGINC}/pngrio.c
  ${WITH_LIBPNGINC}/pngrtran.c
  ${WITH_LIBPNGINC}/pngrutil.c
  ${WITH_LIBPNGINC}/pngset.c
  ${WITH_LIBPNGINC}/pngtrans.c
  ${WITH_LIBPNGINC}/pngwio.c
  ${WITH_LIBPNGINC}/pngwrite.c
  ${WITH_LIBPNGINC}/pngwtran.c
  ${WITH_LIBPNGINC}/pngwutil.c
)

#-----------------------------------------------------------------------------
# Configure for library 
#-----------------------------------------------------------------------------
IF(BUILD_SHARED_LIBS)
  ADD_LIBRARY(${PNG_LIBRARY} SHARED ${LIBPNG_PUBLIC_HDRS} ${LIBPNG_SOURCES})
ELSE(BUILD_SHARED_LIBS)
  ADD_LIBRARY(${PNG_LIBRARY} STATIC ${LIBPNG_PUBLIC_HDRS} ${LIBPNG_SOURCES})
ENDIF(BUILD_SHARED_LIBS)
TARGET_LINK_LIBRARIES(${PNG_LIBRARY} ${ZLIB_LIBRARY} ${M_LIBRARY})
ADD_DEPENDENCIES(${PNG_LIBRARY} ${ZLIB_LIBRARY})

#-----------------------------------------------------------------------------
# Installation
#-----------------------------------------------------------------------------
IF(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL )
  INSTALL(FILES ${LIBPNG_PUBLIC_HDRS} DESTINATION ${DCMTK_INSTALL_INCDIR})
ENDIF()