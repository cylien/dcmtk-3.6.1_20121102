#----------------------------------------------------------------------------
# CMake file for zlib. See root CMakeLists.txt
#----------------------------------------------------------------------------
PROJECT(zlib C)

#-----------------------------------------------------------------------------
# Check for header files
#-----------------------------------------------------------------------------
INCLUDE(${CMAKE_MODULE_PATH}/dcmtkMacros.cmake)
INCLUDE(CheckTypeSize)
INCLUDE(CheckFunctionExists)
INCLUDE(CheckIncludeFile)
INCLUDE(CheckCSourceCompiles)
INCLUDE(CheckSymbolExists)
ENABLE_TESTING()

#-----------------------------------------------------------------------------
# Check for include files, functions and symbols
#-----------------------------------------------------------------------------
CHECK_INCLUDE_FILE(assert.h HAVE_ASSERT_H)
CHECK_INCLUDE_FILE(dlfcn.h HAVE_DLFCN_H)
CHECK_INCLUDE_FILE(fcntl.h HAVE_FCNTL_H)
CHECK_INCLUDE_FILE(inttypes.h HAVE_INTTYPES_H)
CHECK_INCLUDE_FILE(limits.h HAVE_LIMITS_H)
CHECK_INCLUDE_FILE(malloc.h HAVE_MALLOC_H)
CHECK_INCLUDE_FILE(memory.h HAVE_MEMORY_H)
CHECK_INCLUDE_FILE(stdint.h HAVE_STDINT_H)
CHECK_INCLUDE_FILE(stdlib.h HAVE_STDLIB_H)
CHECK_INCLUDE_FILE(strings.h HAVE_STRINGS_H)
CHECK_INCLUDE_FILE(sys/stat.h HAVE_SYS_STAT_H)
CHECK_INCLUDE_FILE(sys/time.h HAVE_SYS_TIME_H)
CHECK_INCLUDE_FILE(time.h HAVE_TIME_H)
CHECK_INCLUDE_FILE(windows.h HAVE_WINDOWS_H)
CHECK_INCLUDE_FILE(ieeefp.h HAVE_IEEEFP_H)
CHECK_INCLUDE_FILE(io.h HAVE_IO_H)
CHECK_INCLUDE_FILE(search.h HAVE_SEARCH_H)
CHECK_INCLUDE_FILE(string.h HAVE_STRING_H)
CHECK_INCLUDE_FILE(sys/types.h HAVE_SYS_TYPES_H)
CHECK_INCLUDE_FILE(unistd.h HAVE_UNISTD_H)

CHECK_FUNCTION_EXISTS(jbg_newlen HAVE_JBG_NEWLEN)
CHECK_FUNCTION_EXISTS(floor HAVE_FLOOR)
CHECK_FUNCTION_EXISTS(getopt HAVE_GETOPT)
CHECK_FUNCTION_EXISTS(isascii HAVE_ISASCII)
CHECK_FUNCTION_EXISTS(memmove HAVE_MEMMOVE)
CHECK_FUNCTION_EXISTS(memset HAVE_MEMSET)
CHECK_FUNCTION_EXISTS(mmap HAVE_MMAP)
CHECK_FUNCTION_EXISTS(pow HAVE_POW)
CHECK_FUNCTION_EXISTS(sqrt HAVE_SQRT)
CHECK_FUNCTION_EXISTS(strcasecmp HAVE_STRCASECMP)
CHECK_FUNCTION_EXISTS(strchr HAVE_STRCHR)
CHECK_FUNCTION_EXISTS(strrchr HAVE_STRRCHR)
CHECK_FUNCTION_EXISTS(strstr HAVE_STRSTR)
CHECK_FUNCTION_EXISTS(strtol HAVE_STRTOL)
CHECK_FUNCTION_EXISTS(areroul HAVE_STRTOUL)
CHECK_INCLUDE_FILE("zlib.h" HAVE_ZLIB_H)

#libtiff does not use the zlib in DCMTK ? if new extension is desired, it
#should be enabled.'
#IF(HAVE_ZLIB_H)
#  SET(ZIP_SUPPORT 1)
#  SET(PIXARLOG_SUPPORT 1) # require zlib
#ENDIF()

#SET(LZMA_SUPPORT 0)
#SET(MDI_SUPPORT 1)
#SET(STDC_HEADERS 1)

SET(DEFAULT_EXTRASAMPLE_AS_ALPHA 1)
SET(CHECK_JPEG_YCBCR_SUBSAMPLING 1)
SET(CCITT_SUPPORT 1)
SET(DEFER_STRILE_LOAD 0)
SET(STRIPCHOP_DEFAULT "TIFF_STRIPCHOP")
SET(STRIP_SIZE_DEFAULT 8192)
SET(SUBIFD_SUPPORT 1)
SET(THUNDER_SUPPORT 1)

CHECK_FUNCTION_EXISTS(getopt HAVE_GETOPT)
CHECK_FUNCTION_EXISTS(isascii HAVE_ISASCII)
CHECK_FUNCTION_EXISTS(memmove HAVE_MEMMOVE)
CHECK_FUNCTION_EXISTS(memset HAVE_MEMSET)
CHECK_FUNCTION_EXISTS(mmap HAVE_MMAP)
CHECK_FUNCTION_EXISTS(strcasecmp HAVE_STRCASECMP)
CHECK_FUNCTION_EXISTS(strchr HAVE_STRCHR)
CHECK_FUNCTION_EXISTS(strrchr HAVE_STRRCHR)
CHECK_FUNCTION_EXISTS(strstr HAVE_STRSTR)
CHECK_FUNCTION_EXISTS(strtol HAVE_STRTOL)
CHECK_FUNCTION_EXISTS(strtoul HAVE_STRTOUL)
CHECK_FUNCTION_EXISTS(strtoull HAVE_STRTOULL)

CHECK_SYMBOL_EXISTS(floor "math.h" HAVE_FLOOR)
CHECK_SYMBOL_EXISTS(sqrt "math.h" HAVE_SQRT)
CHECK_SYMBOL_EXISTS(pow "math.h" HAVE_POW)
CHECK_SYMBOL_EXISTS(lfind "search.h" HAVE_LFIND)
CHECK_SYMBOL_EXISTS(setmod "io.h" HAVE_SETMODE)

CHECK_TYPE_SIZE("signed int"         SIZEOF_SIGNED_INT)
CHECK_TYPE_SIZE("signed long"        SIZEOF_SIGNED_LONG)
CHECK_TYPE_SIZE("signed long long"   SIZEOF_SIGNED_LONG_LONG)
CHECK_TYPE_SIZE("signed short"       SIZEOF_SIGNED_SHORT)
CHECK_TYPE_SIZE("unsigned int"       SIZEOF_UNSIGNED_INT)
CHECK_TYPE_SIZE("unsigned long"      SIZEOF_UNSIGNED_LONG)
CHECK_TYPE_SIZE("unsigned long long" SIZEOF_UNSIGNED_LONG_LONG)
CHECK_TYPE_SIZE("unsigned short"     SIZEOF_UNSIGNED_SHORT)
CHECK_TYPE_SIZE("unsigned char*"     SIZEOF_UNSIGNED_CHAR_P)
CHECK_TYPE_SIZE(ssize_t SSIZE_T)

IF(HAVE_STDINT_H)
  SET(TIFF_INT8_T  int8_t)
  SET(TIFF_INT16_T int16_t)
  SET(TIFF_INT32_T int32_t)
  SET(TIFF_INT64_T int64_t)
  SET(TIFF_UINT8_T uint8_t)
  SET(TIFF_UINT16_T uint16_t)
  SET(TIFF_UINT32_T uint32_t)
  SET(TIFF_UINT64_T uint64_t)
  SET(TIFF_PTRDIFF_T ptrdiff_t)
  IF(NOT HAVE_SSIZE_T)
    IF("${CMAKE_SIZEOF_VOID_P}" EQUAL 8)
      SET(TIFF_SSIZE_T   int64_t)
    ELSEIF("${CMAKE_SIZEOF_VOID_P}" EQUAL 4)
      SET(TIFF_SSIZE_T   int32_t)
    ELSE()
      MESSAGE(FATAL_ERROR "unknown ssize_t")
    ENDIF()
  ELSE(NOT HAVE_SSIZE_T)
    SET(TIFF_SSIZE_T   ssize_t)
  ENDIF()
  SET(TIFF_INT32_FORMAT "\"%d\"")
  SET(TIFF_UINT32_FORMAT "\"%u\"")
  SET(TIFF_INT64_FORMAT "\"%ld\"")
  SET(TIFF_UINT64_FORMAT "\"%lu\"")
  SET(TIFF_PTRDIFF_FORMAT "\"%ld\"")
  SET(TIFF_SSIZE_FORMAT "\"%ld\"")
ENDIF(HAVE_STDINT_H)
# TIFF_FULL_VERSION is from DCMTK_Source/CMake/3rdparty.cmake
SET(PACKAGE_VERSION ${TIFF_FULL_VERSION})
# Note: This still does not test in APPLE
IF(APPLE)
  SET(AC_APPLE_UNIVERSAL_BUILD 1)
ENDIF(APPLE)
IF(UNIX)
  SET(CMAKE_REQUIRED_LIBRARIES m)
  SET(HAVE_LIBM 1)
ENDIF(UNIX)
# http://www.cmake.org/pipermail/cmake/2007-September/016285.html
FOREACH(KEYWORD "inline" "__inline__" "__inline")
  IF(NOT DEFINED C_INLINE)
    TRY_COMPILE(C_HAS_${KEYWORD} "${CMAKE_CURRENT_BINARY_DIR}"
      "${DCMTK_SOURCE_DIR}/support/${TIFF_LIBRARY}/test_inline.c"
       COMPILE_DEFINITIONS "-Dinline=${KEYWORD}")
    IF(C_HAS_${KEYWORD})
      SET(C_INLINE TRUE)
      SET(INLINE "${KEYWORD}")
    ENDIF(C_HAS_${KEYWORD})
  ENDIF(NOT DEFINED C_INLINE)
ENDFOREACH(KEYWORD)

include(${CMAKE_ROOT}/Modules/TestBigEndian.cmake)
TEST_BIG_ENDIAN(WORDS_BIGENDIAN)
set(HOST_BIGENDIAN ${WORDS_BIGENDIAN})
if(HOST_BIGENDIAN)
set(HOST_FILLORDER "FILLORDER_MSB2LSB")
else()
set(HOST_FILLORDER "FILLORDER_LSB2MSB")
endif()

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
IF(UNIX)
  CONFIGURE_FILE(${DCMTK_SOURCE_DIR}/support/${TIFF_LIBRARY}/tiffconf.h.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tiffconf.h @ONLY)
  CONFIGURE_FILE(${DCMTK_SOURCE_DIR}/support/${TIFF_LIBRARY}/tif_config.h.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/${TIFF_LIBRARY}/tif_config.h @ONLY)
ENDIF(UNIX)
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
  INSTALL(TARGETS ${TIFF_LIBRARY}
    RUNTIME DESTINATION ${DCMTK_INSTALL_BINDIR}
    LIBRARY DESTINATION ${DCMTK_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${DCMTK_INSTALL_LIBDIR})
  INSTALL(FILES ${LIBTIFF_PUBLIC_HDRS} DESTINATION ${DCMTK_INSTALL_INCDIR})
ENDIF()
