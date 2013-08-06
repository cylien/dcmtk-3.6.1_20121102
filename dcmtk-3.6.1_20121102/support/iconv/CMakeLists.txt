#----------------------------------------------------------------------------
# CMake file for zlib. See root CMakeLists.txt
#----------------------------------------------------------------------------
PROJECT(iconv C)
#-----------------------------------------------------------------------------
# Check for header files
#-----------------------------------------------------------------------------
INCLUDE(${CMAKE_MODULE_PATH}/dcmtkMacros.cmake)
INCLUDE(${CMAKE_ROOT}/Modules/TestBigEndian.cmake)
INCLUDE(CheckFunctionExists)
INCLUDE(CheckIncludeFile)
INCLUDE(CheckSymbolExists)
INCLUDE(CheckTypeSize)
INCLUDE(CheckCSourceCompiles)

#-----------------------------------------------------------------------------
# Check for include files, functions and symbols
#-----------------------------------------------------------------------------
#CHECK_SYMBOL_EXISTS(mbstate_t "wchar.h" mbstate_t)  #fix it later
CHECK_INCLUDE_FILE(configmake.h LIBDIR)
CHECK_INCLUDE_FILE(errno.h HAVE_ERRNO_H)
CHECK_INCLUDE_FILE(iconv.h HAVE_ICONV)
CHECK_INCLUDE_FILE(stdint.h HAVE_STDINT_H)
CHECK_INCLUDE_FILE(stddef.h HAVE_STDDEF_H)
CHECK_INCLUDE_FILE(stdlib.h HAVE_STDLIB_H)
CHECK_INCLUDE_FILE(string.h HAVE_STRING_H)
CHECK_INCLUDE_FILE(iconv.h HAVE_ICONV)

CHECK_FUNCTION_EXISTS(getc_unlocked HAVE_GETC_UNLOCKED)
CHECK_FUNCTION_EXISTS(mbrtowc HAVE_MBRTOWC)
CHECK_FUNCTION_EXISTS(setlocale HAVE_SETLOCALE)
CHECK_FUNCTION_EXISTS(wcrtomb HAVE_WCRTOMB)
CHECK_INCLUDE_FILE(langinfo.h HAVE_LANGINFO_H)
CHECK_FUNCTION_EXISTS(getc_unlocked HAVE_LANGINFO)
IF(HAVE_LANGINFO_H AND HAVE_LANGINFO)
  SET(HAVE_LANGINFO_CODESET 1)
ENDIF(HAVE_LANGINFO_H AND HAVE_LANGINFO)

TEST_BIG_ENDIAN(WORDS_BIGENDIAN)
SET(HOST_BIGENDIAN ${WORDS_BIGENDIAN})
IF(HOST_BIGENDIAN)
  SET(WORDS_LITTLEENDIAN 1)
ELSE()
  SET(WORDS_LITTLEENDIAN "")
ENDIF()

IF(UNIX)
  SET(ENABLE_RELOCATABLE 1)
  SET(HAVE_WORKING_O_NOFOLLOW 1)
ENDIF(UNIX)
# Define to the value of ${prefix}, as a string
SET(INSTALLPREFIX "")
#IF(NOT LIBDIR)
#  ADD_DEFINITIONS(-DLIBDIR=0)
#ENDIF()
IF(HAVE_ERRNO_H)
  ADD_DEFINITIONS(-DLIBDIR=1)
ENDIF()

# set for Shared libary
IF(BUILD_SHARED_LIBS)
  SET(HAVE_VISIBILITY 1)
ENDIF(BUILD_SHARED_LIBS)

SET(BUILDING_LIBICONV 1)

ENABLE_TESTING()

#-----------------------------------------------------------------------------
# Configuation for header files
#-----------------------------------------------------------------------------
CONFIGURE_FILE(${DCMTK_SOURCE_DIR}/support/${ICONV_LIBRARY}/config.h.in.cmake ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/config.h @ONLY IMMEDIATE)
SET(USE_MBSTATE_T "USE_MBSTATE_T")
SET(BROKEN_WCHAR_H "BROKEN_WCHAR_H")
SET(HAVE_WCHAR_T "HAVE_WCHAR_T")
SET(EILSEQ "EILSEQ")
# depending whether the compiler supports simple visibility declarations.
SET(HAVE_VISIBILITY "HAVE_VISIBILITY")
SET(DLL_VARIABLE "")

#Define as const if the declaration of iconv() needs const.
#dcmtk default definition.
SET(ICONV_CONST "")
IF(MSVC)
 SET(ICONV_CONST "const")
ENDIF(MSVC)

#IF(NOT LIBDIR)
#  ADD_DEFINITIONS(-DLIBDIR=0)
#ENDIF()
#IF(BUILD_SHARED_LIBS)
CONFIGURE_FILE(${WITH_LIBICONVINC}/include/iconv.h.build.in ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/iconv.h @ONLY IMMEDIATE)

#for shared libarry control, fix it later.
#FILE(READ ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/iconv.h CONFIG_H)
#  STRING(REPLACE "#if HAVE_VISIBILITY && BUILDING_LIBICONV" "#if 1" NEW_CONFIG_H ${CONFIG_H})
#  IF(WIN32)
#    STRING(REPLACE "#define ICONV_CONST" "#define ICONV_CONST const" NEW_CONFIG_H ${NEW_CONFIG_H})
#    IF(BUILD_SHARED_LIBS)
#     STRING(REPLACE "#define LIBICONV_DLL_EXPORTED __attribute__((__visibility__(\"default\")))"
#                    "#define __declspec(dllexport)" NEW_CONFIG_H ${NEW_CONFIG_H})
#   ENDIF(BUILD_SHARED_LIBS)
#  ENDIF(WIN32)
#FILE(WRITE ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/iconv.h ${NEW_CONFIG_H})

CONFIGURE_FILE(${WITH_LIBICONVINC}/libcharset/include/libcharset.h.in ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/libcharset.h)
CONFIGURE_FILE(${WITH_LIBICONVINC}/libcharset/include/localcharset.h.build.in ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/localcharset.h)
INCLUDE_DIRECTORIES(${WITH_LIBICONVINC}/lib ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY})

#-----------------------------------------------------------------------------
# iconv
#-----------------------------------------------------------------------------
SET(ICONV_PUBLIC_HDRS
  ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/iconv.h
  ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/config.h
  ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/libcharset.h
  ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/localcharset.h)
SET(ICONV_SOURCES
  ${WITH_LIBICONVINC}/lib/iconv.c
  ${WITH_LIBICONVINC}/libcharset/lib/localcharset.c
  ${WITH_LIBICONVINC}/libcharset/lib/relocatable.c)
ADD_DEFINITIONS(
  -DHAVE_CONFIG_H
  -DENABLE_RELOCATABLE=1
  -DIN_LIBRARY
  -DNO_XMALLOC)

#-----------------------------------------------------------------------------
# Configure for library
#-----------------------------------------------------------------------------
IF(BUILD_SHARED_LIBS)
  ADD_LIBRARY(${ICONV_LIBRARY} SHARED ${ICONV_PUBLIC_HDRS} ${ICONV_SOURCES} ${DCMTK_3RDLIB_DIR}/iconv/iconv.def)
ELSE(BUILD_SHARED_LIBS)
  ADD_LIBRARY(${ICONV_LIBRARY} STATIC ${ICONV_PUBLIC_HDRS} ${ICONV_SOURCES})
ENDIF(BUILD_SHARED_LIBS)

#-----------------------------------------------------------------------------
# Installation
#-----------------------------------------------------------------------------
IF(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL)
  INSTALL(TARGETS ${ICONV_LIBRARY}
    RUNTIME DESTINATION ${DCMTK_INSTALL_BINDIR}
    LIBRARY DESTINATION ${DCMTK_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${DCMTK_INSTALL_LIBDIR})
  INSTALL(FILES ${ICONV_PUBLIC_HDRS} DESTINATION ${DCMTK_INSTALL_INCDIR})
ENDIF()
