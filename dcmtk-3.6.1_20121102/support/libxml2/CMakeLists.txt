#-----------------------------------------------------------------------------
# CMake file for libxml2. See root CMakeLists.txt
#-----------------------------------------------------------------------------
PROJECT(libxml2 C)

#-----------------------------------------------------------------------------
# Check for header files
#-----------------------------------------------------------------------------
INCLUDE(${CMAKE_MODULE_PATH}/dcmtkMacros.cmake)
INCLUDE(CheckTypeSize)
INCLUDE(CheckFunctionExists)
INCLUDE(CheckIncludeFile)
INCLUDE(CheckCSourceCompiles)
ENABLE_TESTING()

#-----------------------------------------------------------------------------
# Check for include files, functions and symbols.
#-----------------------------------------------------------------------------
CHECK_INCLUDE_FILE(stdint.h HAVE_STDINT_H)
CHECK_INCLUDE_FILE(inttypes.h HAVE_INTTYPES_H)
CHECK_INCLUDE_FILE(sys/stat.h HAVE_SYS_STAT_H)
CHECK_INCLUDE_FILE(stdlib.h HAVE_STDLIB_H)
CHECK_INCLUDE_FILE(time.h HAVE_TIME_H)
CHECK_INCLUDE_FILE(fcntl.h HAVE_FCNTL_H)
CHECK_INCLUDE_FILE(ctype.h HAVE_CTYPE_H)
CHECK_INCLUDE_FILE(stdarg.h HAVE_STDARG_H)
CHECK_INCLUDE_FILE(malloc.h HAVE_MALLOC_H)
CHECK_INCLUDE_FILE(errno.h HAVE_ERRNO_H)
CHECK_INCLUDE_FILE(sys/types.h HAVE_SYS_TYPES_H)
CHECK_INCLUDE_FILE(stddef.h HAVE_STDDEF_H)
CHECK_INCLUDE_FILE(stddef.h Z_PREFIX)
CHECK_INCLUDE_FILE(unistd.h Z_HAVE_UNISTD_H)
#OPTION(Z_PREFIX "Enable Z_PREFIX support" ON )
# Check for fseeko
CHECK_FUNCTION_EXISTS(fseeko HAVE_FSEEKO)

#-----------------------------------------------------------------------------
# Configuation for header files
#-----------------------------------------------------------------------------
IF(UNIX)
  CONFIGURE_FILE(${XML2_ORIGN_DIR}/config.h.in ${CMAKE_CURRENT_BINARY_DIR}/${XML2_LIBRARY}/config.h)
ENDIF(UNIX)
IF(WIN32)
  CONFIGURE_FILE(${XML2_ORIGN_DIR}/include/win32config.h ${CMAKE_CURRENT_BINARY_DIR}/${XML2_LIBRARY}/config.h)
  ADD_DEFINITIONS(-DWIN32)
ENDIF(WIN32)
INCLUDE_DIRECTORIES(${XML2_ORIGN_DIR}
  ${XML2_ORIGN_DIR}/include
  ${CMAKE_CURRENT_BINARY_DIR}/${XML2_LIBRARY}
  ${CMAKE_BINARY_DIR}/${3RDLIB_FOLDER_NAME}/${ICONV_LIBRARY}/${ICONV_LIBRARY})

#-----------------------------------------------------------------------------
# libxml2
#-----------------------------------------------------------------------------
SET(LIBXML_PUBLIC_HDRS
  ${XML2_ORIGN_DIR}/buf.h
  ${XML2_ORIGN_DIR}/include/libxml/c14n.h
  ${XML2_ORIGN_DIR}/include/libxml/catalog.h
  ${XML2_ORIGN_DIR}/include/libxml/chvalid.h
  ${XML2_ORIGN_DIR}/include/libxml/debugXML.h
  ${XML2_ORIGN_DIR}/include/libxml/dict.h
  ${XML2_ORIGN_DIR}/include/libxml/DOCBparser.h
  ${XML2_ORIGN_DIR}/include/libxml/encoding.h
  ${XML2_ORIGN_DIR}/include/libxml/entities.h
  ${XML2_ORIGN_DIR}/include/libxml/xmlexports.h
  ${XML2_ORIGN_DIR}/include/libxml/globals.h
  ${XML2_ORIGN_DIR}/include/libxml/hash.h
  ${XML2_ORIGN_DIR}/include/libxml/HTMLparser.h
  ${XML2_ORIGN_DIR}/include/libxml/HTMLtree.h
  ${XML2_ORIGN_DIR}/include/libxml/list.h
  ${XML2_ORIGN_DIR}/include/libxml/nanoftp.h
  ${XML2_ORIGN_DIR}/include/libxml/nanohttp.h
  ${XML2_ORIGN_DIR}/include/libxml/parser.h
  ${XML2_ORIGN_DIR}/include/libxml/parserInternals.h
  ${XML2_ORIGN_DIR}/include/libxml/pattern.h
  ${XML2_ORIGN_DIR}/include/libxml/relaxng.h
  ${XML2_ORIGN_DIR}/include/libxml/SAX2.h
  ${XML2_ORIGN_DIR}/include/libxml/SAX.h
  ${XML2_ORIGN_DIR}/include/libxml/schematron.h
  ${XML2_ORIGN_DIR}/include/libxml/threads.h
  ${XML2_ORIGN_DIR}/include/libxml/tree.h
  ${XML2_ORIGN_DIR}/include/libxml/uri.h
  ${XML2_ORIGN_DIR}/include/libxml/valid.h
  ${XML2_ORIGN_DIR}/include/libxml/xinclude.h
  ${XML2_ORIGN_DIR}/include/libxml/xlink.h
  ${XML2_ORIGN_DIR}/include/libxml/xmlIO.h
  ${XML2_ORIGN_DIR}/include/libxml/xmlmemory.h
  ${XML2_ORIGN_DIR}/include/libxml/xmlreader.h
  ${XML2_ORIGN_DIR}/include/libxml/xmlregexp.h
  ${XML2_ORIGN_DIR}/include/libxml/xmlmodule.h
  ${XML2_ORIGN_DIR}/include/libxml/xmlsave.h
  ${XML2_ORIGN_DIR}/include/libxml/xmlschemas.h
  ${XML2_ORIGN_DIR}/include/libxml/xmlschemastypes.h
  ${XML2_ORIGN_DIR}/include/libxml/xmlunicode.h
  ${XML2_ORIGN_DIR}/include/libxml/xmlwriter.h
  ${XML2_ORIGN_DIR}/include/libxml/xpath.h
  ${XML2_ORIGN_DIR}/include/libxml/xpointer.h
  ${XML2_ORIGN_DIR}/include/libxml/xmlstring.h
)
SET(LIBXML_SRCS
  ${XML2_ORIGN_DIR}/buf.c
  ${XML2_ORIGN_DIR}/c14n.c
  ${XML2_ORIGN_DIR}/catalog.c
  ${XML2_ORIGN_DIR}/chvalid.c
  ${XML2_ORIGN_DIR}/debugXML.c
  ${XML2_ORIGN_DIR}/dict.c
  ${XML2_ORIGN_DIR}/DOCBparser.c
  ${XML2_ORIGN_DIR}/encoding.c
  ${XML2_ORIGN_DIR}/entities.c
  ${XML2_ORIGN_DIR}/error.c
  ${XML2_ORIGN_DIR}/globals.c
  ${XML2_ORIGN_DIR}/hash.c
  ${XML2_ORIGN_DIR}/HTMLparser.c
  ${XML2_ORIGN_DIR}/HTMLtree.c
  ${XML2_ORIGN_DIR}/legacy.c
  ${XML2_ORIGN_DIR}/list.c
  ${XML2_ORIGN_DIR}/nanoftp.c
  ${XML2_ORIGN_DIR}/nanohttp.c
  ${XML2_ORIGN_DIR}/parser.c
  ${XML2_ORIGN_DIR}/parserInternals.c
  ${XML2_ORIGN_DIR}/pattern.c
  ${XML2_ORIGN_DIR}/relaxng.c
  ${XML2_ORIGN_DIR}/SAX2.c
  ${XML2_ORIGN_DIR}/SAX.c
  ${XML2_ORIGN_DIR}/schematron.c
  ${XML2_ORIGN_DIR}/threads.c
  ${XML2_ORIGN_DIR}/tree.c
  ${XML2_ORIGN_DIR}/uri.c
  ${XML2_ORIGN_DIR}/valid.c
  ${XML2_ORIGN_DIR}/xinclude.c
  ${XML2_ORIGN_DIR}/xlink.c
  ${XML2_ORIGN_DIR}/xmlIO.c
  ${XML2_ORIGN_DIR}/xmlmemory.c
  ${XML2_ORIGN_DIR}/xmlreader.c
  ${XML2_ORIGN_DIR}/xmlregexp.c
  ${XML2_ORIGN_DIR}/xmlmodule.c
  ${XML2_ORIGN_DIR}/xmlsave.c
  ${XML2_ORIGN_DIR}/xmlschemas.c
  ${XML2_ORIGN_DIR}/xmlschemastypes.c
  ${XML2_ORIGN_DIR}/xmlunicode.c
  ${XML2_ORIGN_DIR}/xmlwriter.c
  ${XML2_ORIGN_DIR}/xpath.c
  ${XML2_ORIGN_DIR}/xpointer.c
  ${XML2_ORIGN_DIR}/xmlstring.c
)
IF(MSVC)
  SET(MSVC_COMPILE_DEF _CRT_SECURE_NO_WARNINGS _CRT_NONSTDC_NO_WARNINGS)
ENDIF(MSVC)

#-----------------------------------------------------------------------------
# Configure for library
#-----------------------------------------------------------------------------
IF(BUILD_SHARED_LIBS)
  ADD_LIBRARY(${XML2_LIBRARY} SHARED ${LIBXML_SRCS} ${LIBXML_PUBLIC_HDRS})
ELSE(BUILD_SHARED_LIBS)
  ADD_LIBRARY(${XML2_LIBRARY} STATIC ${LIBXML_SRCS} ${LIBXML_PUBLIC_HDRS})
ENDIF(BUILD_SHARED_LIBS)
TARGET_LINK_LIBRARIES(${XML2_LIBRARY} ${WIN32_STD_LIBRARIES} ${ICONV_LIBRARY})
ADD_DEPENDENCIES(${XML2_LIBRARY} ${ICONV_LIBRARY})

#-----------------------------------------------------------------------------
# Installation
#-----------------------------------------------------------------------------
IF(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL )
  INSTALL(DIRECTORY ${XML2_ORIGN_DIR}/include/libxml DESTINATION ${DCMTK_INSTALL_INCDIR}/libxml FILES_MATCHING PATTERN "*.h")
ENDIF()
