IF(WIN32)
  IF(BUILD_WITH_PRE_BUILT_3RD_LIBS)
    # For Windows, we don't used FIND_PACKAGE because DCMTK usually is used with its
    # own set of 3rd-party support libraries that can be downloaded from DCMTK's
    # website (pre-built).

    # libxml support: find out whether user has library
    GET_FILENAME_COMPONENT(LIBXML_DIR "${DCMTK_SOURCE_DIR}/../libxml2-2.7.7" ABSOLUTE)
    FIND_PATH(WITH_LIBXMLINC "/include/libxml/parser.h" "${LIBXML_DIR}"/ NO_DEFAULT_PATH)
    MARK_AS_ADVANCED(LIBXML_DIR WITH_LIBXMLINC)

    # libpng support: find out whether user has library
    GET_FILENAME_COMPONENT(LIBPNG_DIR "${DCMTK_SOURCE_DIR}/../libpng-1.4.2" ABSOLUTE)
    FIND_PATH(WITH_LIBPNGINC "include/png.h" "${LIBPNG_DIR}" NO_DEFAULT_PATH)
    MARK_AS_ADVANCED(LIBPNG_DIR WITH_LIBPNGINC)

    # libtiff support: find out whether user has library
    GET_FILENAME_COMPONENT(LIBTIFF_DIR "${DCMTK_SOURCE_DIR}/../tiff-3.9.2" ABSOLUTE)
    FIND_PATH(WITH_LIBTIFFINC "include/tiff.h" "${LIBTIFF_DIR}" NO_DEFAULT_PATH)
    MARK_AS_ADVANCED(LIBTIFF_DIR WITH_LIBTIFFINC)

    # OpenSSL support: find out whether user has library
    GET_FILENAME_COMPONENT(OPENSSL_DIR "${DCMTK_SOURCE_DIR}/../openssl-1.0.0" ABSOLUTE)
    FIND_PATH(WITH_OPENSSLINC "include/openssl/ssl.h" "${OPENSSL_DIR}" NO_DEFAULT_PATH)
    MARK_AS_ADVANCED(OPENSSL_DIR WITH_OPENSSLINC)

    # zlib support: find out whether user has library
    GET_FILENAME_COMPONENT(ZLIB_DIR "${DCMTK_SOURCE_DIR}/../zlib-1.2.5" ABSOLUTE)
    FIND_PATH(WITH_ZLIBINC "include/zlib.h" "${ZLIB_DIR}" NO_DEFAULT_PATH)
    MARK_AS_ADVANCED(ZLIB_DIR WITH_ZLIBINC)

    # sndfile support: find out whether user has library. Needed for module dcmwave (not in public DCMTK yet, marked as advanced)
    GET_FILENAME_COMPONENT(SNDFILE_DIR "${DCMTK_SOURCE_DIR}/../libsndfile-1.0.17" ABSOLUTE)
    FIND_PATH(WITH_SNDFILEINC "sndfile.h" "${SNDFILE_DIR}" NO_DEFAULT_PATH)
    MARK_AS_ADVANCED(SNDFILE_DIR WITH_SNDFILEINC)

    # libiconv support: find out whether user has library
    GET_FILENAME_COMPONENT(LIBICONV_DIR "${DCMTK_SOURCE_DIR}/../libiconv-1.14" ABSOLUTE)
    FIND_PATH(WITH_LIBICONVINC "include/iconv.h" "${LIBICONV_DIR}" NO_DEFAULT_PATH)
    MARK_AS_ADVANCED(LIBXML_DIR WITH_LIBXMLINC)

    # libxml support: configure compiler
    IF(DCMTK_WITH_XML)
      IF(WITH_LIBXMLINC)
        SET(LIBXML_INCDIR ${WITH_LIBXMLINC}/include)
        SET(LIBXML_LIBDIR ${WITH_LIBXMLINC}/lib)
        SET(LIBXML_LIBS debug libxml2_d optimized libxml2_o debug iconv_d optimized iconv_o)
        MESSAGE(STATUS "Info: DCMTK XML support will be enabled")
        SET(WITH_LIBXML 1)
      ELSE(WITH_LIBXMLINC) # turn off library if library path not set
        MESSAGE(STATUS "Warning: XML support will be disabled because libxml2 directory is not specified. Correct path and re-enable DCMTK_WITH_XML.")
        SET(DCMTK_WITH_XML OFF CACHE BOOL "" FORCE)
        SET(WITH_LIBXML "")
      ENDIF(WITH_LIBXMLINC)
    ENDIF(DCMTK_WITH_XML)

    # libpng support: configure compiler
    IF(DCMTK_WITH_PNG)
      IF(WITH_LIBPNGINC)
        SET(LIBPNG_INCDIR ${WITH_LIBPNGINC}/include)
        SET(LIBPNG_LIBDIR ${WITH_LIBPNGINC}/lib)
        SET(LIBPNG_LIBS debug libpng_d optimized libpng_o)
        MESSAGE(STATUS "Info: DCMTK PNG support will be enabled")
        SET(WITH_LIBPNG 1)
      ELSE(WITH_LIBPNGINC) # turn off library if library path not set
        MESSAGE(STATUS "Warning: PNG support will be disabled because libpng directory was not specified. Correct path and re-enable DCMTK_WITH_PNG.")
        SET(DCMTK_WITH_PNG OFF CACHE BOOL "" FORCE)
        SET(WITH_LIBPNG "")
      ENDIF(WITH_LIBPNGINC)
    ENDIF(DCMTK_WITH_PNG)

    # libtiff support: configure compiler
    IF(DCMTK_WITH_TIFF)
      IF(WITH_LIBTIFFINC)
        SET(LIBTIFF_INCDIR ${WITH_LIBTIFFINC}/include)
        SET(LIBTIFF_LIBDIR ${WITH_LIBTIFFINC}/lib)
        SET(LIBTIFF_LIBS debug libtiff_d optimized libtiff_o)
        MESSAGE(STATUS "Info: DCMTK TIFF support will be enabled")
        SET(WITH_LIBTIFF 1)
      ELSE(WITH_LIBTIFFINC) # turn off library if library path not set
        MESSAGE(STATUS "Warning: TIFF support will be disabled because libtiff directory was not specified. Correct path and re-enable DCMTK_WITH_TIFF.")
        SET(DCMTK_WITH_TIFF OFF CACHE BOOL "" FORCE)
        SET(WITH_LIBTIFF "")
      ENDIF(WITH_LIBTIFFINC)
    ENDIF(DCMTK_WITH_TIFF)

    # OpenSSL support: configure compiler
    IF(DCMTK_WITH_OPENSSL)
      IF(WITH_OPENSSLINC)
        SET(OPENSSL_BINDIR ${WITH_OPENSSLINC}/bin)
        SET(OPENSSL_INCDIR ${WITH_OPENSSLINC}/include)
        SET(OPENSSL_LIBDIR ${WITH_OPENSSLINC}/lib)
        SET(OPENSSL_LIBS debug dcmtkssl_d.lib optimized dcmtkssl_o.lib debug dcmtkeay_d.lib optimized dcmtkeay_o.lib)
        MESSAGE(STATUS "Info: DCMTK OPENSSL support will be enabled")
        SET(WITH_OPENSSL 1)
      ELSE(WITH_OPENSSLINC) # turn off library if library path not set
        MESSAGE(STATUS "Warning: OPENSSL support will be disabled because openssl directory was not specified. Correct path and re-enable DCMTK_WITH_OPENSSL.")
        SET(DCMTK_WITH_OPENSSL OFF CACHE BOOL "" FORCE)
        SET(WITH_OPENSSL "")
      ENDIF(WITH_OPENSSLINC)
    ENDIF(DCMTK_WITH_OPENSSL)

    # zlib support: configure compiler
    IF(DCMTK_WITH_ZLIB)
      IF(WITH_ZLIBINC)
        SET(ZLIB_INCDIR ${WITH_ZLIBINC}/include)
        SET(ZLIB_LIBDIR ${WITH_ZLIBINC}/lib)
        SET(ZLIB_LIBS debug zlib_d optimized zlib_o)
        MESSAGE(STATUS "Info: DCMTK ZLIB support will be enabled")
        SET(WITH_ZLIB 1)
      ELSE(WITH_ZLIBINC) # turn off library if library path not set
        MESSAGE(STATUS "Warning: ZLIB support will be disabled because zlib directory was not specified. Correct path and re-enable DCMTK_WITH_ZLIB.")
        SET(DCMTK_WITH_ZLIB OFF CACHE BOOL "" FORCE)
        SET(WITH_ZLIB "")
      ENDIF(WITH_ZLIBINC)
    ENDIF(DCMTK_WITH_ZLIB)

    # sndfile support: configure compiler
    IF(DCMTK_WITH_SNDFILE)
      IF(WITH_SNDFILEINC)
        SET(SNDFILE_INCDIR ${WITH_SNDFILEINC}/include)
        SET(SNDFILE_LIBDIR ${WITH_SNDFILEINC}/lib)
        SET(SNDFILE_LIBS debug libsndfile_d optimized libsndfile_o)
        MESSAGE(STATUS "Info: DCMTK SNDFILE support will be enabled")
        SET(WITH_SNDFILE 1)
      ELSE(WITH_SNDFILEINC) # turn off library if library path not set
        MESSAGE(STATUS "Warning: SNDFILE support will be disabled because libsndfile directory was not specified. Correct path and re-enable DCMTK_WITH_SNDFILE.")
        SET(DCMTK_WITH_SNDFILE OFF CACHE BOOL "" FORCE)
        SET(WITH_SNDFILE "")
      ENDIF(WITH_SNDFILEINC)
    ENDIF(DCMTK_WITH_SNDFILE)

    # libiconv support: configure compiler
    IF(DCMTK_WITH_ICONV)
      IF(WITH_LIBICONVINC)
        SET(LIBICONV_INCDIR ${WITH_LIBICONVINC}/include)
        SET(LIBICONV_LIBDIR ${WITH_LIBICONVINC}/lib)
        SET(LIBICONV_LIBS debug libiconv_d optimized libiconv_o debug libchset_d optimized libchset_o)
        MESSAGE(STATUS "Info: DCMTK ICONV support will be enabled")
        SET(WITH_LIBICONV 1)
      ELSE(WITH_LIBICONVINC) # turn off library if library path not set
        MESSAGE(STATUS "Warning: ICONV support will be disabled because libiconv directory was not specified. Correct path and re-enable DCMTK_WITH_ICONV.")
        SET(DCMTK_WITH_ICONV OFF CACHE BOOL "" FORCE)
        SET(WITH_LIBICONV "")
      ENDIF(WITH_LIBICONVINC)
    ENDIF(DCMTK_WITH_ICONV)
  ENDIF(BUILD_WITH_PRE_BUILT_3RD_LIBS)
ENDIF(WIN32)

  IF(BUILD_WITH_3RD_LIBS)
  # For Windows, we don't used FIND_PACKAGE because DCMTK usually is used with its
  # own set of 3rd-party support libraries that can be downloaded from the
  # offical sites.

    SET(3RDLIB_FOLDER_NAME support)
    SET(DCMTK_3RDLIB_DIR ${DCMTK_SOURCE_DIR}/${3RDLIB_FOLDER_NAME})
    SET(ZLIB_LIBRARY    "zlib")
    SET(TIFF_LIBRARY    "libtiff")
    SET(PNG_LIBRARY     "libpng")
    SET(ICONV_LIBRARY   "iconv")
    SET(XML2_LIBRARY    "libxml2")
    SET(OPENSSL_LIBRARY "openssl")
    SET(SSL_LIBRARY "ssleay32")
    SET(CRYPTO_LIBRARY "libeay32")

    # libxml support: find out whether user has library
    GET_FILENAME_COMPONENT(XML2_ORIGN_DIR "${DCMTK_SOURCE_DIR}/../3rdlib/libxml2-2.9.0" ABSOLUTE)
    FIND_PATH(WITH_LIBXMLINC "/include/libxml/parser.h" "${XML2_ORIGN_DIR}"/ NO_DEFAULT_PATH)

    # libtiff support: find out whether user has library
    GET_FILENAME_COMPONENT(TIFF_ORIGN_DIR "${DCMTK_SOURCE_DIR}/../3rdlib/tiff-4.0.3" ABSOLUTE)
    FIND_PATH(WITH_LIBTIFFINC "VERSION" "${TIFF_ORIGN_DIR}" NO_DEFAULT_PATH)

    # libtiff support: find out whether user has library
    GET_FILENAME_COMPONENT(PNG_ORIGN_DIR "${DCMTK_SOURCE_DIR}/../3rdlib/lpng1513" ABSOLUTE)
    FIND_PATH(WITH_LIBPNGINC "png.h" "${PNG_ORIGN_DIR}" NO_DEFAULT_PATH)

    # OpenSSL support: find out whether user has library
    GET_FILENAME_COMPONENT(OPENSSL_ORIGN_DIR "${DCMTK_SOURCE_DIR}/../3rdlib/openssl-1.0.1c" ABSOLUTE)
    FIND_PATH(WITH_OPENSSLINC "include/openssl/ssl.h" "${OPENSSL_ORIGN_DIR}" NO_DEFAULT_PATH)

    # zlib support: find out whether user has library
    GET_FILENAME_COMPONENT(ZLIB_ORIGN_DIR "${DCMTK_SOURCE_DIR}/../3rdlib/zlib-1.2.7" ABSOLUTE)
    FIND_PATH(WITH_ZLIBINC "zlib.h" "${ZLIB_ORIGN_DIR}" NO_DEFAULT_PATH)

    # libiconv support: find out whether user has library
    GET_FILENAME_COMPONENT(ICONV_ORIGN_DIR "${DCMTK_SOURCE_DIR}/../3rdlib/libiconv-1.14" ABSOLUTE)
    FIND_PATH(WITH_LIBICONVINC "include/iconv.h.in" "${ICONV_ORIGN_DIR}" NO_DEFAULT_PATH)

     # libxml support: configure compiler
    IF(DCMTK_WITH_XML)
      IF(WITH_LIBXMLINC)
        # parse the full version number from libxml2.spec and include in LIBXML2_FULL_VERSION
        FILE(READ ${WITH_LIBXMLINC}/libxml2.spec LIBXML2_SPEC)
        STRING(REGEX REPLACE ".*Version:[ \t]+([-0-9A-Za-z.]+).*" "\\1" LIBXML2_FULL_VERSION ${LIBXML2_SPEC})
        MESSAGE(STATUS "Info: DCMTK XML support will be enabled, XML version: ${LIBXML2_FULL_VERSION}")
        SET(LIBXML_LIBS ${XML2_LIBRARY})
        SET(LIBXML_INCDIR ${CMAKE_BINARY_DIR}/${3RDLIB_FOLDER_NAME}/${XML2_LIBRARY}/${XML2_LIBRARY} ${WITH_LIBXMLINC}/include ${CMAKE_BINARY_DIR}/${3RDLIB_FOLDER_NAME}/${ICONV_LIBRARY}/${ICONV_LIBRARY})
        SET(WITH_LIBXML 1)
        ADD_SUBDIRECTORY(${DCMTK_3RDLIB_DIR}/${XML2_LIBRARY})
      ELSE(WITH_LIBXMLINC) # turn off library if library path not set
        MESSAGE(STATUS "Warning: XML support will be disabled because libxml2 directory is not specified. Correct path and re-enable DCMTK_WITH_XML.")
        SET(DCMTK_WITH_XML OFF CACHE BOOL "" FORCE)
        SET(WITH_LIBXML "")
      ENDIF(WITH_LIBXMLINC)
    ENDIF(DCMTK_WITH_XML)

    # libtiff support: configure compiler
    IF(DCMTK_WITH_TIFF)
      IF(WITH_LIBTIFFINC)
        # parse the full version number from VERSION and include in TIFF_FULL_VERSION
        FILE(READ ${WITH_LIBTIFFINC}/VERSION TIFF_FULL_VERSION)
        STRING(REGEX REPLACE "([-0-9A-Za-z]+).*." "\\1" TIFF_MAJOR_VERSION ${TIFF_FULL_VERSION})
        MESSAGE(STATUS "Info: DCMTK TIFF support will be enabled, TIFF version: ${TIFF_FULL_VERSION}")
        SET(LIBTIFF_LIBS ${TIFF_LIBRARY})
        SET(LIBTIFF_INCDIR ${CMAKE_BINARY_DIR}/${3RDLIB_FOLDER_NAME}/${TIFF_LIBRARY}/${TIFF_LIBRARY} ${WITH_LIBTIFFINC})
        SET(WITH_TIFF 1)
        ADD_SUBDIRECTORY(${DCMTK_3RDLIB_DIR}/${TIFF_LIBRARY})
      ELSE(WITH_LIBTIFFINC) # turn off library if library path not set
        MESSAGE(STATUS "Warning: TIFF support will be disabled because libtiff directory was not specified. Correct path and re-enable DCMTK_WITH_TIFF.")
        SET(DCMTK_WITH_TIFF OFF CACHE BOOL "" FORCE)
        SET(WITH_LIBTIFF "")
      ENDIF(WITH_LIBTIFFINC)
    ENDIF(DCMTK_WITH_TIFF)

    # libpng support: configure compiler
    IF(DCMTK_WITH_PNG)
      IF(WITH_LIBPNGINC)
        # parse the full version number from png.h and include in PNG_FULL_VERSION
        FILE(READ ${WITH_LIBPNGINC}/png.h _png_h_contents)
        STRING(REGEX REPLACE ".*#define[ \t]+PNG_LIBPNG_VER_STRING[ \t]+\"([-0-9A-Za-z.]+)\".*"
          "\\1" PNG_FULL_VERSION ${_png_h_contents})
        STRING(REGEX REPLACE "([-0-9A-Za-z]+).*." "\\1" PNG_MAJOR_VERSION ${PNG_FULL_VERSION})
        MESSAGE(STATUS "Info: DCMTK PNG support will be enabled, PNG version: ${PNG_FULL_VERSION}")
        SET(LIBPNG_LIBS ${PNG_LIBRARY})
        SET(LIBPNG_INCDIR ${CMAKE_BINARY_DIR}/${3RDLIB_FOLDER_NAME}/${PNG_LIBRARY}/${PNG_LIBRARY} ${WITH_LIBPNGINC})
        SET(WITH_PNG 1)
        ADD_SUBDIRECTORY(${DCMTK_3RDLIB_DIR}/${PNG_LIBRARY})
      ELSE(WITH_LIBPNGINC) # turn off library if library path not set
        MESSAGE(STATUS "Warning: PNG support will be disabled because libpng directory was not specified. Correct path and re-enable DCMTK_WITH_PNG.")
        SET(DCMTK_WITH_PNG OFF CACHE BOOL "" FORCE)
        SET(WITH_LIBPNG "")
      ENDIF(WITH_LIBPNGINC)
    ENDIF(DCMTK_WITH_PNG)

    # zlib support: configure compiler
    IF(DCMTK_WITH_ZLIB)
      IF(WITH_ZLIBINC)
        # parse the full version number from zlib.h and include in ZLIB_FULL_VERSION
        FILE(READ ${WITH_ZLIBINC}/zlib.h _zlib_h_contents)
        STRING(REGEX REPLACE ".*#define[ \t]+ZLIB_VERSION[ \t]+\"([-0-9A-Za-z.]+)\".*"
               "\\1" ZLIB_FULL_VERSION ${_zlib_h_contents})
        STRING(REGEX REPLACE "([-0-9A-Za-z]+).*." "\\1" ZLIB_MAJOR_VERSION ${ZLIB_FULL_VERSION})
        MESSAGE(STATUS "Info: DCMTK ZLIB support will be enabled, ZLIB version: ${ZLIB_FULL_VERSION}")
        SET(ZLIB_LIBS ${ZLIB_LIBRARY})
        SET(ZLIB_INCDIR ${CMAKE_BINARY_DIR}/${3RDLIB_FOLDER_NAME}/${ZLIB_LIBRARY}/${ZLIB_LIBRARY} ${WITH_ZLIBINC})
        SET(WITH_ZLIB 1)
        ADD_SUBDIRECTORY(${DCMTK_3RDLIB_DIR}/${ZLIB_LIBRARY})
      ELSE(WITH_ZLIBINC) # turn off library if library path not set
        MESSAGE(STATUS "Warning: ZLIB support will be disabled because zlib directory was not specified. Correct path and re-enable DCMTK_WITH_ZLIB.")
        SET(DCMTK_WITH_ZLIB OFF CACHE BOOL "" FORCE)
        SET(WITH_ZLIB "")
      ENDIF(WITH_ZLIBINC)
    ENDIF(DCMTK_WITH_ZLIB)

    # OpenSSL support: configure compiler
    IF(DCMTK_WITH_OPENSSL)
      IF(WITH_OPENSSLINC)
        # parse the full version number from openssl.spec and include in OPENSSL_FULL_VERSION
        FILE(READ ${WITH_OPENSSLINC}/openssl.spec OPENSSL_SPEC)
        STRING(REGEX REPLACE ".*%define[ \t]libmaj[ \t]+([-0-9A-Za-z]+).*" "\\1" OPENSSL_V_MAJ ${OPENSSL_SPEC})
        STRING(REGEX REPLACE ".*%define[ \t]libmin[ \t]+([-0-9A-Za-z]+).*" "\\1" OPENSSL_V_MIN ${OPENSSL_SPEC})
        STRING(REGEX REPLACE ".*%define[ \t]librel[ \t]+([-0-9A-Za-z]+).*" "\\1" OPENSSL_V_REL ${OPENSSL_SPEC})
        STRING(REGEX REPLACE ".*%define[ \t]librev[ \t]+([-0-9A-Za-z]+).*" "\\1" OPENSSL_V_REV ${OPENSSL_SPEC})
        SET(OPENSSL_FULL_VERSION "${OPENSSL_V_MAJ}.${OPENSSL_V_MIN}.${OPENSSL_V_REL}.${OPENSSL_V_REV}")
        SET(OPENSSL_LIBS ${CRYPTO_LIBRARY} ${SSL_LIBRARY})
        SET(OPENSSL_BINDIR ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
        SET(OPENSSL_INCDIR ${CMAKE_BINARY_DIR}/${3RDLIB_FOLDER_NAME}/${OPENSSL_LIBRARY}/${OPENSSL_LIBRARY}/inc32/ ${WITH_OPENSSLINC})
        MESSAGE(STATUS "Info: DCMTK OPENSSL support will be enabled, OPENSSL version: ${OPENSSL_FULL_VERSION}")
        SET(WITH_OPENSSL 1)
        ADD_SUBDIRECTORY(${DCMTK_3RDLIB_DIR}/${OPENSSL_LIBRARY})
      ELSE(WITH_OPENSSLINC) # turn off library if library path not set
        MESSAGE(STATUS "Warning: OPENSSL support will be disabled because openssl directory was not specified. Correct path and re-enable DCMTK_WITH_OPENSSL.")
        SET(DCMTK_WITH_OPENSSL OFF CACHE BOOL "" FORCE)
        SET(WITH_OPENSSL "")
      ENDIF(WITH_OPENSSLINC)
    ENDIF(DCMTK_WITH_OPENSSL)

    # libiconv support: configure compiler
    IF(DCMTK_WITH_ICONV)
      IF(WITH_LIBICONVINC)
        # parse the full version number from iconv.h and include in ICONV_FULL_VERSION
        FILE(READ ${WITH_LIBICONVINC}/include/iconv.h.build.in _iconv_h_contents)
        STRING(REGEX REPLACE ".*#define[ \t]+_LIBICONV_VERSION[ \t]+([-0-9A-Za-z]+).*"
               "\\1" ICONV_FULL_VERSION ${_iconv_h_contents})
        STRING(SUBSTRING ${ICONV_FULL_VERSION} 3 1 ICONV_MAJOR_VERSION)
        MESSAGE(STATUS "Info: DCMTK ICONV support will be enabled, ICONV version: ${ICONV_FULL_VERSION}")
        SET(LIBICONV_LIBS ${ICONV_LIBRARY})
        SET(LIBICONV_INCDIR ${WITH_LIBICONVINC} ${WITH_LIBICONVINC}/include ${CMAKE_BINARY_DIR}/${3RDLIB_FOLDER_NAME}/${ICONV_LIBRARY}/${ICONV_LIBRARY})
        SET(WITH_LIBICONV 1)
        ADD_SUBDIRECTORY(${DCMTK_3RDLIB_DIR}/${ICONV_LIBRARY})
      ELSE(WITH_LIBICONVINC) # turn off library if library path not set
        MESSAGE(STATUS "Warning: ICONV support will be disabled because libiconv directory was not specified. Correct path and re-enable DCMTK_WITH_ICONV.")
        SET(DCMTK_WITH_ICONV OFF CACHE BOOL "" FORCE)
        SET(WITH_LIBICONV "")
      ENDIF(WITH_LIBICONVINC)
    ENDIF(DCMTK_WITH_ICONV)

  ENDIF(BUILD_WITH_3RD_LIBS)