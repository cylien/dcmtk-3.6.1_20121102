#----------------------------------------------------------------------------
# CMake file for zlib. See root CMakeLists.txt
#----------------------------------------------------------------------------
PROJECT(zlib C)

#-----------------------------------------------------------------------------
# Check for header files
#-----------------------------------------------------------------------------
INCLUDE(${CMAKE_MODULE_PATH}/dcmtkMacros.cmake)
INCLUDE(CheckFunctionExists)
INCLUDE(CheckIncludeFile)
ENABLE_TESTING()

#-----------------------------------------------------------------------------
# Check for include files, functions and symbols
#-----------------------------------------------------------------------------
# Check if header file exists and add it to the list.
#-----------------------------------------------------------------------------
CHECK_INCLUDE_FILE(assert.h HAVE_ASSERT_H)
CHECK_INCLUDE_FILE(fcntl.h HAVE_FCNTL_H)
CHECK_INCLUDE_FILE(io.h HAVE_IO_H)
CHECK_INCLUDE_FILE(search.h HAVE_SEARCH_H)
CHECK_INCLUDE_FILE(string.h HAVE_STRING_H)
CHECK_INCLUDE_FILE(sys/types.h HAVE_SYS_TYPES_H)
CHECK_INCLUDE_FILE(unistd.h HAVE_UNISTD_H)
CHECK_FUNCTION_EXISTS(jbg_newlen HAVE_JBG_NEWLEN)
CHECK_FUNCTION_EXISTS(mmap HAVE_MMAP)

#-----------------------------------------------------------------------------
# Configuation for header files
#-----------------------------------------------------------------------------
IF(WIN32)
  set(USE_WIN32_FILEIO 1)
  CONFIGURE_FILE(${WITH_LIBTIFFINC}/libtiff/tiffconf.vc.h ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tiffconf.h @ONLY)
  CONFIGURE_FILE(${WITH_LIBTIFFINC}/libtiff/tif_config.vc.h ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tif_config.h @ONLY)
  FILE(READ ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tiffconf.h CONFIG_H)
  #Bug-fixed, init64 defined in gcc, see: http://ubuntuforums.org/showthread.php?t=889612
  IF(MINGW)
    STRING(REPLACE "#define _TIFFCONF_" "#define _TIFFCONF_\r\n#include <inttypes.h>" NEW_CONFIG_H ${CONFIG_H})
    FILE(WRITE ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tiffconf.h ${NEW_CONFIG_H})
  ENDIF(MINGW)
ENDIF(WIN32)
IF(NOT WIN32)
  CONFIGURE_FILE(${WITH_LIBTIFFINC}/libtiff/tiffconf.h.in ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tiffconf.h.h @ONLY)
  CONFIGURE_FILE(${WITH_LIBTIFFINC}/libtiff/tif_config.h.in ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tif_config.h @ONLY)
ENDIF()
INCLUDE_DIRECTORIES(${WITH_LIBTIFFINC} ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY})

#-----------------------------------------------------------------------------
# zlib
#-----------------------------------------------------------------------------
SET(LIBTIFF_PUBLIC_HDRS
  ${WITH_LIBTIFFINC}/libtiff/tiff.h
  ${WITH_LIBTIFFINC}/libtiff/tiffvers.h
  ${WITH_LIBTIFFINC}/libtiff/tiffio.h
  ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tiffconf.h
  ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tif_config.h)
SET(LIBTIFF_SRCS
  ${WITH_LIBTIFFINC}/libtiff/tif_aux.c
  ${WITH_LIBTIFFINC}/libtiff/tif_close.c
  ${WITH_LIBTIFFINC}/libtiff/tif_codec.c
  ${WITH_LIBTIFFINC}/libtiff/tif_color.c
  ${WITH_LIBTIFFINC}/libtiff/tif_compress.c
  ${WITH_LIBTIFFINC}/libtiff/tif_dir.c
  ${WITH_LIBTIFFINC}/libtiff/tif_dirinfo.c
  ${WITH_LIBTIFFINC}/libtiff/tif_dirread.c
  ${WITH_LIBTIFFINC}/libtiff/tif_dirwrite.c
  ${WITH_LIBTIFFINC}/libtiff/tif_dumpmode.c
  ${WITH_LIBTIFFINC}/libtiff/tif_error.c
  ${WITH_LIBTIFFINC}/libtiff/tif_extension.c
  ${WITH_LIBTIFFINC}/libtiff/tif_fax3.c
  ${WITH_LIBTIFFINC}/libtiff/tif_fax3sm.c
  ${WITH_LIBTIFFINC}/libtiff/tif_getimage.c
  ${WITH_LIBTIFFINC}/libtiff/tif_jbig.c
  ${WITH_LIBTIFFINC}/libtiff/tif_jpeg.c
  ${WITH_LIBTIFFINC}/libtiff/tif_jpeg_12.c
  ${WITH_LIBTIFFINC}/libtiff/tif_ojpeg.c
  ${WITH_LIBTIFFINC}/libtiff/tif_flush.c
  ${WITH_LIBTIFFINC}/libtiff/tif_luv.c
  ${WITH_LIBTIFFINC}/libtiff/tif_lzw.c
  ${WITH_LIBTIFFINC}/libtiff/tif_next.c
  ${WITH_LIBTIFFINC}/libtiff/tif_open.c
  ${WITH_LIBTIFFINC}/libtiff/tif_packbits.c
  ${WITH_LIBTIFFINC}/libtiff/tif_pixarlog.c
  ${WITH_LIBTIFFINC}/libtiff/tif_predict.c
  ${WITH_LIBTIFFINC}/libtiff/tif_print.c
  ${WITH_LIBTIFFINC}/libtiff/tif_read.c
  ${WITH_LIBTIFFINC}/libtiff/tif_stream.cxx
  ${WITH_LIBTIFFINC}/libtiff/tif_swab.c
  ${WITH_LIBTIFFINC}/libtiff/tif_strip.c
  ${WITH_LIBTIFFINC}/libtiff/tif_thunder.c
  ${WITH_LIBTIFFINC}/libtiff/tif_tile.c
  ${WITH_LIBTIFFINC}/libtiff/tif_version.c
  ${WITH_LIBTIFFINC}/libtiff/tif_warning.c
  ${WITH_LIBTIFFINC}/libtiff/tif_write.c
  ${WITH_LIBTIFFINC}/libtiff/tif_zip.c)
IF(UNIX)
  LIST(APPEND LIBTIFF_SRCS ${WITH_LIBTIFFINC}/libtiff/tif_unix.c)
  IF(CMAKE_COMPILER_IS_GNUCXX OR CV_ICC)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
  ENDIF()
ENDIF(UNIX)
IF(WIN32)
  LIST(APPEND LIBTIFF_SRCS ${WITH_LIBTIFFINC}/libtiff/tif_win32.c)
ENDIF(WIN32)

#-----------------------------------------------------------------------------
# Configure for library
#-----------------------------------------------------------------------------
IF(BUILD_SHARED_LIBS)
  ADD_LIBRARY(${TIFF_LIBRARY} SHARED ${LIBTIFF_PUBLIC_HDRS} ${LIBTIFF_SRCS} ${WITH_LIBTIFFINC}/libtiff/libtiff.def)
ELSE(BUILD_SHARED_LIBS)
  ADD_LIBRARY(${TIFF_LIBRARY} STATIC ${LIBTIFF_PUBLIC_HDRS} ${LIBTIFF_SRCS})
ENDIF(BUILD_SHARED_LIBS)
TARGET_LINK_LIBRARIES(${TIFF_LIBRARY} ${ZLIB_LIBRARY})
ADD_DEPENDENCIES(${TIFF_LIBRARY} ${ZLIB_LIBRARY})

#-----------------------------------------------------------------------------
# Installation
#-----------------------------------------------------------------------------
IF(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL )
  INSTALL(FILES ${LIBTIFF_PUBLIC_HDRS} DESTINATION ${DCMTK_INSTALL_INCDIR})
ENDIF()
