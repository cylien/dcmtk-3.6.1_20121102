#----------------------------------------------------------------------------
# CMake file for zlib. See root CMakeLists.txt
#----------------------------------------------------------------------------
PROJECT(iconv C)
#-----------------------------------------------------------------------------
# Check for header files
#-----------------------------------------------------------------------------
INCLUDE(${CMAKE_MODULE_PATH}/dcmtkMacros.cmake)
INCLUDE(CheckFunctionExists)
INCLUDE(CheckIncludeFile)
INCLUDE(CheckSymbolExists)
CHECK_INCLUDE_FILE(configmake.h LIBDIR)
CHECK_INCLUDE_FILE(errno.h HAVE_ERRNO_H)
CHECK_SYMBOL_EXISTS(EILSEQ "errno.h" HAVE_EILSEQ)
#IF(NOT LIBDIR)
#  ADD_DEFINITIONS(-DLIBDIR=0)
#ENDIF()
IF(HAVE_ERRNO_H)
  ADD_DEFINITIONS(-DLIBDIR=1)
ENDIF()
ENABLE_TESTING()

#-----------------------------------------------------------------------------
# Configuation for header files
#-----------------------------------------------------------------------------
# Marco: ICONV_CONFIG used to replace @varible@ as "varible" in iconv.h.build.in
# or iconv.h.in to create iconv.h for share and static link
MACRO(ICONV_CONFIG VARIBLE)
  SET(VARIBLE ${VARIBLE})
  CONFIGURE_FILE(${WITH_LIBICONVINC}/include/iconv.h.in ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/iconv.h @ONLY IMMEDIATE)
ENDMACRO(ICONV_CONFIG VARIBLE)

SET(USE_MBSTATE_T "USE_MBSTATE_T")
SET(BROKEN_WCHAR_H "BROKEN_WCHAR_H")
SET(HAVE_WCHAR_T "HAVE_WCHAR_T")
SET(EILSEQ "EILSEQ")
SET(HAVE_VISIBILITY "HAVE_VISIBILITY")
SET(DLL_VARIABLE "")
#SET(ICONV_CONST "const")
ICONV_CONFIG(${USE_MBSTATE_T} ${BROKEN_WCHAR_H} ${HAVE_WCHAR_T} ${ICONV_CONST} ${HAVE_VISIBILITY} ${DLL_VARIABLE})

FILE(READ ${WITH_LIBICONVINC}/lib/config.h.in CONFIG_H)
STRING(REPLACE "#undef ICONV_CONST" "#define ICONV_CONST const" NEW_CONFIG_H ${CONFIG_H})
FILE(WRITE ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/config.h ${NEW_CONFIG_H})

FILE(READ ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/config.h CONFIG_H)
# undefine EILSEQ will cause a error of the undeclared EILSEQ which is already defined in errno.h.
STRING(REPLACE "#undef EILSEQ" "//#undef EILSEQ" NEW_CONFIG_H ${CONFIG_H})
FILE(WRITE ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/config.h ${NEW_CONFIG_H})

CONFIGURE_FILE(${WITH_LIBICONVINC}/libcharset/include/libcharset.h.in ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/libcharset.h)
CONFIGURE_FILE(${WITH_LIBICONVINC}/libcharset/include/localcharset.h.in ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/localcharset.h)
INCLUDE_DIRECTORIES(${WITH_LIBICONVINC}/lib ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY})

#-----------------------------------------------------------------------------
# iconv
#-----------------------------------------------------------------------------
SET(ICONV_PUBLIC_HDRS
  ${CMAKE_CURRENT_BINARY_DIR}/${ICONV_LIBRARY}/iconv.h
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
  INSTALL(FILES ${ICONV_PUBLIC_HDRS} DESTINATION ${DCMTK_INSTALL_INCDIR})
ENDIF()
