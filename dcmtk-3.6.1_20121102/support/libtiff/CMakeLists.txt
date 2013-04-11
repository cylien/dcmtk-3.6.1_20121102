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
  CONFIGURE_FILE(${TIFF_ORIGN_DIR}/libtiff/tiffconf.vc.h ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tiffconf.h @ONLY)
  CONFIGURE_FILE(${TIFF_ORIGN_DIR}/libtiff/tif_config.vc.h ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tif_config.h @ONLY)
  FILE(READ ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tiffconf.h CONFIG_H)
  #Bug-fixed, init64 defined in gcc, see: http://ubuntuforums.org/showthread.php?t=889612
  IF(MINGW)
    STRING(REPLACE "#define _TIFFCONF_" "#define _TIFFCONF_\r\n#include <inttypes.h>" NEW_CONFIG_H ${CONFIG_H})
    FILE(WRITE ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tiffconf.h ${NEW_CONFIG_H})
  ENDIF(MINGW)
ENDIF(WIN32)
IF(NOT WIN32)
  CONFIGURE_FILE(${TIFF_ORIGN_DIR}/libtiff/tiffconf.h.in ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tiffconf.h.h @ONLY)
  CONFIGURE_FILE(${TIFF_ORIGN_DIR}/libtiff/tif_config.h.in ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tif_config.h @ONLY)
ENDIF()
INCLUDE_DIRECTORIES(${TIFF_ORIGN_DIR} ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY})

#-----------------------------------------------------------------------------
# zlib
#-----------------------------------------------------------------------------
SET(LIBTIFF_PUBLIC_HDRS
  ${TIFF_ORIGN_DIR}/libtiff/tiff.h
  ${TIFF_ORIGN_DIR}/libtiff/tiffvers.h
  ${TIFF_ORIGN_DIR}/libtiff/tiffio.h
  ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tiffconf.h
  ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tif_config.h)
SET(LIBTIFF_SRCS
  ${TIFF_ORIGN_DIR}/libtiff/tif_aux.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_close.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_codec.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_color.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_compress.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_dir.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_dirinfo.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_dirread.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_dirwrite.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_dumpmode.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_error.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_extension.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_fax3.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_fax3sm.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_getimage.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_jbig.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_jpeg.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_jpeg_12.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_ojpeg.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_flush.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_luv.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_lzw.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_next.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_open.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_packbits.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_pixarlog.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_predict.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_print.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_read.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_stream.cxx
  ${TIFF_ORIGN_DIR}/libtiff/tif_swab.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_strip.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_thunder.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_tile.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_version.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_warning.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_write.c
  ${TIFF_ORIGN_DIR}/libtiff/tif_zip.c)
IF(UNIX)
  LIST(APPEND LIBTIFF_SRCS ${TIFF_ORIGN_DIR}/libtiff/tif_unix.c)
  IF(CMAKE_COMPILER_IS_GNUCXX OR CV_ICC)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
  ENDIF()
ENDIF(UNIX)
IF(WIN32)
  LIST(APPEND LIBTIFF_SRCS ${TIFF_ORIGN_DIR}/libtiff/tif_win32.c)
ENDIF(WIN32)

#-----------------------------------------------------------------------------
# Configure for library
#-----------------------------------------------------------------------------
IF(BUILD_SHARED_LIBS)
  ADD_LIBRARY(${TIFF_LIBRARY} SHARED ${LIBTIFF_PUBLIC_HDRS} ${LIBTIFF_SRCS} ${TIFF_ORIGN_DIR}/libtiff/libtiff.def)
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
