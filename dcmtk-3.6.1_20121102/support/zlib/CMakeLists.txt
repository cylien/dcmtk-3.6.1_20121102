#----------------------------------------------------------------------------
# CMake file for zlib. See root CMakeLists.txt
#----------------------------------------------------------------------------
PROJECT(zlib C)

#-----------------------------------------------------------------------------
# Check for header files
#-----------------------------------------------------------------------------
INCLUDE(CheckTypeSize)
INCLUDE(CheckFunctionExists)
INCLUDE(CheckIncludeFile)
INCLUDE(CheckCSourceCompiles)
ENABLE_TESTING()

#-----------------------------------------------------------------------------
# Check for include files, functions and symbols.
#-----------------------------------------------------------------------------
INCLUDE(${CMAKE_MODULE_PATH}/dcmtkMacros.cmake)
CHECK_INCLUDE_FILE(sys/types.h HAVE_SYS_TYPES_H)
#CHECK_INCLUDE_FILE(stdint.h   HAVE_STDINT_H)
CHECK_INCLUDE_FILE(stddef.h    HAVE_STDDEF_H)
CHECK_INCLUDE_FILE(stddef.h    Z_PREFIX)
CHECK_INCLUDE_FILE(unistd.h    Z_HAVE_UNISTD_H)
#OPTION(Z_PREFIX "Enable Z_PREFIX support" ON )
# Check for fseeko
CHECK_FUNCTION_EXISTS(fseeko HAVE_FSEEKO)
IF(NOT HAVE_FSEEKO)
  ADD_DEFINITIONS(-DNO_FSEEKO)
ENDIF(NOT HAVE_FSEEKO)
IF(BUILD_SHARED_LIBS)
  ADD_DEFINITIONS(-DZLIB_DLL)
ENDIF(BUILD_SHARED_LIBS)
# Check to see if we have large file support
SET(CMAKE_REQUIRED_DEFINITIONS -D_LARGEFILE64_SOURCE=1)

#-----------------------------------------------------------------------------
# Configuation for header files
#-----------------------------------------------------------------------------
IF(NOT CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_CURRENT_BINARY_DIR)
    # If we're doing an out of source build and the user has a zconf.h
    # in their source tree
    IF(EXISTS ${WITH_ZLIBINC}/zconf.h)
        MESSAGE(STATUS "Renaming")
        MESSAGE(STATUS "${WITH_ZLIBINC}/zconf.h")
        MESSAGE(STATUS "to 'zconf.h.included' because this file is included with zlib")
        MESSAGE(STATUS "but CMake generates it automatically in the build directory.")
        FILE(RENAME ${WITH_ZLIBINC}/zconf.h ${WITH_ZLIBINC}/zconf.h.included)
  ENDIF()
endif()
SET(ZLIB_PC ${WITH_ZLIBINC}/zlib.pc)
CONFIGURE_FILE(${WITH_ZLIBINC}/zlib.pc.cmakein ${ZLIB_PC} @ONLY)
CONFIGURE_FILE(${WITH_ZLIBINC}/zconf.h.cmakein ${CMAKE_CURRENT_BINARY_DIR}/${ZLIB_LIBRARY}/zconf.h @ONLY)
INCLUDE_DIRECTORIES(${WITH_ZLIBINC} ${CMAKE_CURRENT_BINARY_DIR}/${ZLIB_LIBRARY})

#-----------------------------------------------------------------------------
# zlib
#-----------------------------------------------------------------------------
set(ZLIB_PUBLIC_HDRS
  ${CMAKE_CURRENT_BINARY_DIR}/${ZLIB_LIBRARY}/zconf.h
  ${WITH_ZLIBINC}/zlib.h)
set(ZLIB_PRIVATE_HDRS
  ${WITH_ZLIBINC}/crc32.h
  ${WITH_ZLIBINC}/deflate.h
  ${WITH_ZLIBINC}/gzguts.h
  ${WITH_ZLIBINC}/inffast.h
  ${WITH_ZLIBINC}/inffixed.h
  ${WITH_ZLIBINC}/inflate.h
  ${WITH_ZLIBINC}/inftrees.h
  ${WITH_ZLIBINC}/trees.h
  ${WITH_ZLIBINC}/zutil.h)
set(ZLIB_SRCS
  ${WITH_ZLIBINC}/adler32.c
  ${WITH_ZLIBINC}/compress.c
  ${WITH_ZLIBINC}/crc32.c
  ${WITH_ZLIBINC}/deflate.c
  ${WITH_ZLIBINC}/gzclose.c
  ${WITH_ZLIBINC}/gzlib.c
  ${WITH_ZLIBINC}/gzread.c
  ${WITH_ZLIBINC}/gzwrite.c
  ${WITH_ZLIBINC}/inflate.c
  ${WITH_ZLIBINC}/infback.c
  ${WITH_ZLIBINC}/inftrees.c
  ${WITH_ZLIBINC}/inffast.c
  ${WITH_ZLIBINC}/trees.c
  ${WITH_ZLIBINC}/uncompr.c
  ${WITH_ZLIBINC}/zutil.c)

IF(NOT MINGW)
  # If present will override custom build rule below.
  SET(ZLIB_SRCS ${ZLIB_SRCS} ${WITH_ZLIBINC}/win32/zlib1.rc)
ENDIF(NOT MINGW)

IF(MINGW)
  # This gets us DLL resource information when compiling on MinGW.
  IF(NOT CMAKE_RC_COMPILER)
    SET(CMAKE_RC_COMPILER windres.exe)
  ENDIF()
  ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${ZLIB_LIBRARY}/zlib1rc.obj
    COMMAND ${CMAKE_RC_COMPILER}
            -D GCC_WINDRES
            -I ${WITH_ZLIBINC}
            -I $${CMAKE_CURRENT_BINARY_DIR}/${ZLIB_LIBRARY}/
            -o ${CMAKE_CURRENT_BINARY_DIR}/${ZLIB_LIBRARY}/zlib1rc.obj
            -i ${WITH_ZLIBINC}/win32/zlib1.rc)
  SET(ZLIB_SRCS ${ZLIB_SRCS} ${CMAKE_CURRENT_BINARY_DIR}/${ZLIB_LIBRARY}/zlib1rc.obj)
ENDIF(MINGW)

#-----------------------------------------------------------------------------
# Configure for library
#-----------------------------------------------------------------------------
IF(BUILD_SHARED_LIBS)
  ADD_LIBRARY(${ZLIB_LIBRARY} SHARED ${ZLIB_PUBLIC_HDRS} ${ZLIB_PRIVATE_HDRS} ${ZLIB_SRCS})
ELSE(BUILD_SHARED_LIBS)
  ADD_LIBRARY(${ZLIB_LIBRARY} STATIC ${ZLIB_PUBLIC_HDRS} ${ZLIB_PRIVATE_HDRS} ${ZLIB_SRCS})
ENDIF(BUILD_SHARED_LIBS)

#-----------------------------------------------------------------------------
# Installation
#-----------------------------------------------------------------------------
IF(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL )
  INSTALL(FILES ${ZLIB_PUBLIC_HDRS} DESTINATION ${DCMTK_INSTALL_INCDIR})
ENDIF()
