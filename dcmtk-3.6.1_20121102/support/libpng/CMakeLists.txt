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
  ADD_DEFINITIONS(-DPNG_BUILD_DLL)
ENDIF(BUILD_SHARED_LIBS)
ENABLE_TESTING()
#-----------------------------------------------------------------------------
# Configuation for header files
#-----------------------------------------------------------------------------
# Use the prebuilt pnglibconf.h file from the scripts folder
# TODO: fix this by building with awk; without this no cmake build can be
# configured directly (to do so indirectly use your local awk to build a
# pnglibconf.h in the build directory.)
CONFIGURE_FILE(${PNG_ORIGN_DIR}/scripts/pnglibconf.h.prebuilt          
               ${CMAKE_CURRENT_BINARY_DIR}/${PNG_LIBRARY}/pnglibconf.h)              
INCLUDE_DIRECTORIES(${PNG_ORIGN_DIR} 
  ${CMAKE_CURRENT_BINARY_DIR}/${PNG_LIBRARY} 
  ${ZLIB_ORIGN_DIR}
  ${CMAKE_BINARY_DIR}/${3RDLIB_FOLDER_NAME}/${ZLIB_LIBRARY}/${ZLIB_LIBRARY})

#-----------------------------------------------------------------------------
# libpng
#-----------------------------------------------------------------------------
set(LIBPNG_PUBLIC_HDRS
  ${PNG_ORIGN_DIR}/png.h
  ${PNG_ORIGN_DIR}/pngconf.h
  ${CMAKE_CURRENT_BINARY_DIR}/${PNG_LIBRARY}/pnglibconf.h
)
set(LIBPNG_SOURCES
  ${PNG_ORIGN_DIR}/pngdebug.h
  ${PNG_ORIGN_DIR}/pnginfo.h
  ${PNG_ORIGN_DIR}/pngpriv.h
  ${PNG_ORIGN_DIR}/pngstruct.h
  ${PNG_ORIGN_DIR}/png.c
  ${PNG_ORIGN_DIR}/pngerror.c
  ${PNG_ORIGN_DIR}/pngget.c
  ${PNG_ORIGN_DIR}/pngmem.c
  ${PNG_ORIGN_DIR}/pngpread.c
  ${PNG_ORIGN_DIR}/pngread.c
  ${PNG_ORIGN_DIR}/pngrio.c
  ${PNG_ORIGN_DIR}/pngrtran.c
  ${PNG_ORIGN_DIR}/pngrutil.c
  ${PNG_ORIGN_DIR}/pngset.c
  ${PNG_ORIGN_DIR}/pngtrans.c
  ${PNG_ORIGN_DIR}/pngwio.c
  ${PNG_ORIGN_DIR}/pngwrite.c
  ${PNG_ORIGN_DIR}/pngwtran.c
  ${PNG_ORIGN_DIR}/pngwutil.c
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