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
INCLUDE(CheckSymbolExists)
ENABLE_TESTING()

#-----------------------------------------------------------------------------
# Check for include files, functions and symbofls.
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
CHECK_INCLUDE_FILE(sys/mman.h HAVE_SYS_MMAN_H)
CHECK_INCLUDE_FILE(sys/ndir.h HAVE_SYS_NDIR_H)
CHECK_INCLUDE_FILE(sys/timeb.h HAVE_SYS_TIMEB_H)
CHECK_INCLUDE_FILE(unistd.h Z_HAVE_UNISTD_H)
CHECK_INCLUDE_FILE(zlib.h HAVE_ZLIB_H)
CHECK_INCLUDE_FILE(ansidecl.h HAVE_ANSIDECL_H)
CHECK_INCLUDE_FILE(arpa/nameser.h HAVE_ARPA_NAMESER_H)
CHECK_INCLUDE_FILE(dlfcn.h HAVE_DLFCN_H)
CHECK_INCLUDE_FILE(dl.h HAVE_DL_H)
CHECK_INCLUDE_FILE(ansidecl.h HAVE_ANSIDECL_H)
CHECK_INCLUDE_FILE(arpa/nameser.h HAVE_ARPA_NAMESER_H)
CHECK_INCLUDE_FILE(fp_class.h HAVE_FP_CLASS_H)
CHECK_INCLUDE_FILE(ieeefp.h HAVE_IEEEFP_H)
CHECK_INCLUDE_FILE(lzma.h HAVE_LZMA_H)
CHECK_INCLUDE_FILE(nan.h HAVE_NAN_H)
CHECK_INCLUDE_FILE(ndir.h HAVE_NDIR_H)
CHECK_INCLUDE_FILE(poll.h HAVE_POLL_H)
CHECK_INCLUDE_FILE(resolv.h HAVE_RESOLV_H)

#OPTION(Z_PREFIX "Enable Z_PREFIX support" ON )
# Check for fseeko
CHECK_FUNCTION_EXISTS(fseeko HAVE_FSEEKO)
CHECK_FUNCTION_EXISTS(vsnprintf HAVE_VSNPRINTF)
CHECK_FUNCTION_EXISTS(snprintf HAVE_SNPRINTF)
CHECK_FUNCTION_EXISTS(sprintf HAVE_SPRINTF)
CHECK_FUNCTION_EXISTS(srand HAVE_SRAND)
CHECK_FUNCTION_EXISTS(sscanf HAVE_SSCANF)
CHECK_FUNCTION_EXISTS(stat HAVE_STAT)
CHECK_FUNCTION_EXISTS(strftime HAVE_STRFTIME)
CHECK_FUNCTION_EXISTS(strndup HAVE_STRNDUP)
CHECK_FUNCTION_EXISTS(vfprintf HAVE_VFPRINTF)
CHECK_FUNCTION_EXISTS(vsprintf HAVE_VSPRINTF)
CHECK_FUNCTION_EXISTS(_stat HAVE__STAT)
CHECK_FUNCTION_EXISTS(time HAVE_TIME)
CHECK_FUNCTION_EXISTS(fpclass HAVE_FPCLASS)
CHECK_FUNCTION_EXISTS(fprintf HAVE_FPRINTF)
CHECK_FUNCTION_EXISTS(fp_class HAVE_FP_CLASS)
CHECK_FUNCTION_EXISTS(gettimeofday HAVE_GETTIMEOFDAY)
CHECK_FUNCTION_EXISTS(isnand HAVE_ISNAND)
CHECK_FUNCTION_EXISTS(localtime HAVE_LOCALTIME)
CHECK_FUNCTION_EXISTS(munmap HAVE_MUNMAP)
CHECK_FUNCTION_EXISTS(printf HAVE_PRINTF)
CHECK_FUNCTION_EXISTS(putenv HAVE_PUTENV)
CHECK_FUNCTION_EXISTS(rand HAVE_RAND)
CHECK_FUNCTION_EXISTS(rand_r HAVE_RAND_R)
CHECK_FUNCTION_EXISTS(signal HAVE_SIGNAL)

# ICONV_CONST should be the same with iconv which is default by empty, i.e., #define ICONV_CONST
SET(ICONV_CONST 1)
#dcmtk defualt definiton is: empty
IF(WIN32)
  SET(ICONV_CONST_TYPE "const")
ELSE(WIN32)
  SET(ICONV_CONST_TYPE "")
ENDIF(WIN32)

#IF(ICONV_CONST)
#  SET(ICONV_CONST_TYPE const)
#ENDIF(ICONV_CONST)
IF(HAVE_STDARG_H)
   SET(HAVE_VA_COPY 1)
   SET(HAVE___VA_COPY 1)
ENDIF(HAVE_STDARG_H)

#undef
#-----------------------------------------------------------------------------
# Configuation for header files
#-----------------------------------------------------------------------------
IF(UNIX)
  CONFIGURE_FILE(${DCMTK_SOURCE_DIR}/support/${XML2_LIBRARY}/config.h.in.cmake ${CMAKE_CURRENT_BINARY_DIR}/${XML2_LIBRARY}/config.h)
  CONFIGURE_FILE(${WITH_LIBXMLINC}/include/libxml/xmlexports.h ${CMAKE_CURRENT_BINARY_DIR}/${XML2_LIBRARY}/xmlexports.h)
ENDIF(UNIX)
IF(WIN32)
  CONFIGURE_FILE(${WITH_LIBXMLINC}/include/win32config.h ${CMAKE_CURRENT_BINARY_DIR}/${XML2_LIBRARY}/config.h)
  ADD_DEFINITIONS(-DWIN32)
  # _imp__xmlFree listed is as missing in mingw for static link. see ./include/xml/xmlexports.h in more detail.
  IF(MINGW)
    FILE(READ ${WITH_LIBXMLINC}/include/libxml/xmlexports.h XMLEXPORTS_H)
      STRING(REPLACE "by also making that declaration when compiling client code.\n   */\n  #if defined(IN_LIBXML) && !defined(LIBXML_STATIC)"
        "by also making that declaration when compiling client code.\n   */\n  #if !defined(LIBXML_STATIC)" NEW_XMLEXPORTS_H ${XMLEXPORTS_H})
    FILE(WRITE ${CMAKE_CURRENT_BINARY_DIR}/${XML2_LIBRARY}/libxml/xmlexports.h ${NEW_XMLEXPORTS_H})
  ELSE(MINGW)
    FILE(COPY ${WITH_LIBXMLINC}/include/libxml/xmlexports.h DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/${XML2_LIBRARY}/libxml/xmlexports.h ${NEW_XMLEXPORTS_H})
  ENDIF(MINGW)
ENDIF(WIN32)


INCLUDE_DIRECTORIES(${WITH_LIBXMLINC}
  ${WITH_LIBXMLINC}/include
  ${CMAKE_CURRENT_BINARY_DIR}/${XML2_LIBRARY}
  ${CMAKE_BINARY_DIR}/${3RDLIB_FOLDER_NAME}/${ICONV_LIBRARY}/${ICONV_LIBRARY}
  ${CMAKE_BINARY_DIR}/${3RDLIB_FOLDER_NAME}/${ZLIB_LIBRARY}/${ZLIB_LIBRARY})

#-----------------------------------------------------------------------------
# libxml2
#-----------------------------------------------------------------------------
SET(LIBXML_PUBLIC_HDRS
  ${CMAKE_CURRENT_BINARY_DIR}/${XML2_LIBRARY}/config.h
  ${WITH_LIBXMLINC}/buf.h
  ${WITH_LIBXMLINC}/include/libxml/c14n.h
  ${WITH_LIBXMLINC}/include/libxml/catalog.h
  ${WITH_LIBXMLINC}/include/libxml/chvalid.h
  ${WITH_LIBXMLINC}/include/libxml/debugXML.h
  ${WITH_LIBXMLINC}/include/libxml/dict.h
  ${WITH_LIBXMLINC}/include/libxml/DOCBparser.h
  ${WITH_LIBXMLINC}/include/libxml/encoding.h
  ${WITH_LIBXMLINC}/include/libxml/entities.h
  ${WITH_LIBXMLINC}/include/libxml/globals.h
  ${WITH_LIBXMLINC}/include/libxml/hash.h
  ${WITH_LIBXMLINC}/include/libxml/HTMLparser.h
  ${WITH_LIBXMLINC}/include/libxml/HTMLtree.h
  ${WITH_LIBXMLINC}/include/libxml/list.h
  ${WITH_LIBXMLINC}/include/libxml/nanoftp.h
  ${WITH_LIBXMLINC}/include/libxml/nanohttp.h
  ${WITH_LIBXMLINC}/include/libxml/parser.h
  ${WITH_LIBXMLINC}/include/libxml/parserInternals.h
  ${WITH_LIBXMLINC}/include/libxml/pattern.h
  ${WITH_LIBXMLINC}/include/libxml/relaxng.h
  ${WITH_LIBXMLINC}/include/libxml/SAX2.h
  ${WITH_LIBXMLINC}/include/libxml/SAX.h
  ${WITH_LIBXMLINC}/include/libxml/schematron.h
  ${WITH_LIBXMLINC}/include/libxml/threads.h
  ${WITH_LIBXMLINC}/include/libxml/tree.h
  ${WITH_LIBXMLINC}/include/libxml/uri.h
  ${WITH_LIBXMLINC}/include/libxml/valid.h
  ${WITH_LIBXMLINC}/include/libxml/xinclude.h
  ${WITH_LIBXMLINC}/include/libxml/xlink.h
  ${WITH_LIBXMLINC}/include/libxml/xmlIO.h
  ${WITH_LIBXMLINC}/include/libxml/xmlmemory.h
  ${WITH_LIBXMLINC}/include/libxml/xmlreader.h
  ${WITH_LIBXMLINC}/include/libxml/xmlregexp.h
  ${WITH_LIBXMLINC}/include/libxml/xmlmodule.h
  ${WITH_LIBXMLINC}/include/libxml/xmlsave.h
  ${WITH_LIBXMLINC}/include/libxml/xmlschemas.h
  ${WITH_LIBXMLINC}/include/libxml/xmlschemastypes.h
  ${WITH_LIBXMLINC}/include/libxml/xmlunicode.h
  ${WITH_LIBXMLINC}/include/libxml/xmlwriter.h
  ${WITH_LIBXMLINC}/include/libxml/xpath.h
  ${WITH_LIBXMLINC}/include/libxml/xpointer.h
  ${WITH_LIBXMLINC}/include/libxml/xmlstring.h
)
SET(LIBXML_SRCS
  ${WITH_LIBXMLINC}/buf.c
  ${WITH_LIBXMLINC}/c14n.c
  ${WITH_LIBXMLINC}/catalog.c
  ${WITH_LIBXMLINC}/chvalid.c
  ${WITH_LIBXMLINC}/debugXML.c
  ${WITH_LIBXMLINC}/dict.c
  ${WITH_LIBXMLINC}/DOCBparser.c
  ${WITH_LIBXMLINC}/encoding.c
  ${WITH_LIBXMLINC}/entities.c
  ${WITH_LIBXMLINC}/error.c
  ${WITH_LIBXMLINC}/globals.c
  ${WITH_LIBXMLINC}/hash.c
  ${WITH_LIBXMLINC}/HTMLparser.c
  ${WITH_LIBXMLINC}/HTMLtree.c
  ${WITH_LIBXMLINC}/legacy.c
  ${WITH_LIBXMLINC}/list.c
  ${WITH_LIBXMLINC}/nanoftp.c
  ${WITH_LIBXMLINC}/nanohttp.c
  ${WITH_LIBXMLINC}/parser.c
  ${WITH_LIBXMLINC}/parserInternals.c
  ${WITH_LIBXMLINC}/pattern.c
  ${WITH_LIBXMLINC}/relaxng.c
  ${WITH_LIBXMLINC}/SAX2.c
  ${WITH_LIBXMLINC}/SAX.c
  ${WITH_LIBXMLINC}/schematron.c
  ${WITH_LIBXMLINC}/threads.c
  ${WITH_LIBXMLINC}/tree.c
  ${WITH_LIBXMLINC}/uri.c
  ${WITH_LIBXMLINC}/valid.c
  ${WITH_LIBXMLINC}/xinclude.c
  ${WITH_LIBXMLINC}/xlink.c
  ${WITH_LIBXMLINC}/xmlIO.c
  ${WITH_LIBXMLINC}/xmlmemory.c
  ${WITH_LIBXMLINC}/xmlreader.c
  ${WITH_LIBXMLINC}/xmlregexp.c
  ${WITH_LIBXMLINC}/xmlmodule.c
  ${WITH_LIBXMLINC}/xmlsave.c
  ${WITH_LIBXMLINC}/xmlschemas.c
  ${WITH_LIBXMLINC}/xmlschemastypes.c
  ${WITH_LIBXMLINC}/xmlunicode.c
  ${WITH_LIBXMLINC}/xmlwriter.c
  ${WITH_LIBXMLINC}/xpath.c
  ${WITH_LIBXMLINC}/xpointer.c
  ${WITH_LIBXMLINC}/xmlstring.c
)
IF(MINGW OR UNIX)
  LIST(APPEND LIBXML_PUBLIC_HDRS ${CMAKE_CURRENT_BINARY_DIR}/${XML2_LIBRARY}/libxml/xmlexports.h)
ENDIF(MINGW OR UNIX)
IF(MSVC)
  SET(MSVC_COMPILE_DEF _CRT_SECURE_NO_WARNINGS _CRT_NONSTDC_NO_WARNINGS)
ENDIF(MSVC)

#-----------------------------------------------------------------------------
# Configure for library
#-----------------------------------------------------------------------------
IF(BUILD_SHARED_LIBS)
  ADD_DEFINITIONS(-fPIC )
  ADD_LIBRARY(${XML2_LIBRARY} SHARED ${LIBXML_SRCS} ${LIBXML_PUBLIC_HDRS})
ELSE(BUILD_SHARED_LIBS)
  ADD_LIBRARY(${XML2_LIBRARY} STATIC ${LIBXML_SRCS} ${LIBXML_PUBLIC_HDRS})
ENDIF(BUILD_SHARED_LIBS)
TARGET_LINK_LIBRARIES(${XML2_LIBRARY} ${WIN32_STD_LIBRARIES} ${ICONV_LIBRARY} ${ZLIB_LIBRARY})
ADD_DEPENDENCIES(${XML2_LIBRARY} ${ICONV_LIBRARY} ${ZLIB_LIBRARY})

#-----------------------------------------------------------------------------
# Installation
#-----------------------------------------------------------------------------
IF(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL )
  INSTALL(TARGETS ${XML2_LIBRARY}
    RUNTIME DESTINATION ${DCMTK_INSTALL_BINDIR}
    LIBRARY DESTINATION ${DCMTK_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${DCMTK_INSTALL_LIBDIR})
  INSTALL(DIRECTORY ${WITH_LIBXMLINC}/include/libxml DESTINATION ${DCMTK_INSTALL_INCDIR}/libxml FILES_MATCHING PATTERN "*.h")
ENDIF()
