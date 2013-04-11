#----------------------------------------------------------------------------
# CMake file for openssl. See root CMakeLists.txt
#----------------------------------------------------------------------------
PROJECT(openssl C)

#-----------------------------------------------------------------------------
# Check for header files
#-----------------------------------------------------------------------------
INCLUDE(${CMAKE_CURRENT_SOURCE_DIR}/PerlFileList.cmake)
FIND_PROGRAM(PERL perl)
IF(NOT PERL)
  MESSAGE(SEND_ERROR "PERL does not be installed.")
ENDIF()
SET(SSL_LIBRARY "ssleay32")
SET(CRYPTO_LIBRARY "libeay32")
SET(OUTPUT_SSL_NAME "dcmtkssl")
SET(OUTPUT_CRYPTO_NAME "dcmtkeay")
ENABLE_TESTING()

#-----------------------------------------------------------------------------
# Check for include files, functions and symbols
#-----------------------------------------------------------------------------
# The temporary directory for everything intersting all the  work
SET(TMP_D ${CMAKE_CURRENT_BINARY_DIR}/${OPENSSL_LIBRARY}/tmp32)
SET(TMPDLL_D ${CMAKE_CURRENT_BINARY_DIR}/${OPENSSL_LIBRARY}/tmp32dll)
# The output directory for all the headers
SET(INC_D ${CMAKE_CURRENT_BINARY_DIR}/${OPENSSL_LIBRARY}/inc32)
SET(INCO_D ${CMAKE_CURRENT_BINARY_DIR}/${OPENSSL_LIBRARY}/inc32/openssl)
# The source directory
SET(SSL_SRC ${OPENSSL_ORIGN_DIR}/ssl)
SET(CRYPTO_SRC ${OPENSSL_ORIGN_DIR}/crypto)
SET(ENGS_SRC ${OPENSSL_ORIGN_DIR}/engines)
SET(MK_DIRS ${TMP_D} ${INC_D} ${INCO_D} ${INCO_D} ${OUTDLL_D} ${TMPDLL_D})
FILE(MAKE_DIRECTORY ${MK_DIRS})
FILE(READ ${CRYPTO_SRC}/cversion.c CVERSION_C)
# undefine #include "buildinf.h" will cause a error generated automatically from perl commmand
STRING(REGEX REPLACE "#include .buildinf.h." "// disable #included buildinf.h by CY Lien" NEW_CONFIG_H "${CVERSION_C}")
FILE(WRITE ${CRYPTO_SRC}/cversion.c "${NEW_CONFIG_H}")

#-----------------------------------------------------------------------------
# Defininitions of library
#-----------------------------------------------------------------------------
# General definitions
IF(WIN32)
  IF(BUILD_SHARED_LIBS)
    ADD_DEFINITIONS(-D_WINDLL -DOPENSSL_NO_STATIC_ENGINE -DNO_ASM)
  ELSE()
    ADD_DEFINITIONS(-DOPENSSL_NO_DYNAMIC_ENGINE)
  ENDIF(BUILD_SHARED_LIBS)
  ADD_DEFINITIONS(-DOPENSSL_THREADS -DL_ENDIAN -DDSO_WIN32 -DWIN32_LEAN_AND_MEAN
    -DOPENSSL_NO_RC5 -DOPENSSL_NO_MD2 -DOPENSSL_NO_KRB5 -DOPENSSL_NO_JPAKE)
  IF(MSVC)
    ADD_DEFINITIONS(-DOPENSSL_SYSNAME_WIN32 -D_CRT_SECURE_NO_DEPRECATE -INO_WINDOWS_BRAINDEATH)
    SET(WIN32_LIBRARIES ws2_32 netapi32 wsock32 crypt32 gdi32 advapi32 user32)
  ENDIF(MSVC)
  IF(MINGW)
    ADD_DEFINITIONS(-D_MT -fomit-frame-pointer -Wall)
    SET(WIN32_LIBRARIES ws2_32 gdi32 crypt32)
  ENDIF(MINGW)
ENDIF(WIN32)

#-----------------------------------------------------------------------------
# Perl and NASM. Configuation for header files by perl script
#-----------------------------------------------------------------------------
SET(PL_CP_FILES)
IF(WIN32)
  IF(MSVC)
    ADD_CUSTOM_COMMAND(OUTPUT ${OPENSSL_ORIGN_DIR}/Configure
        COMMAND ${PERL} Configure no-asm VC-WIN32
        WORKING_DIRECTORY ${OPENSSL_ORIGN_DIR})
     SET(COPY_CMD ${PERL} util/copy.pl)
  ENDIF(MSVC)
  IF(MINGW)
    ADD_CUSTOM_COMMAND(OUTPUT ${OPENSSL_ORIGN_DIR}/Configure
        COMMAND ${PERL} Configure no-asm mingw
        WORKING_DIRECTORY ${OPENSSL_ORIGN_DIR})
    SET(COPY_CMD cmake -E copy)
  ENDIF(MINGW)
  FOREACH(_FILE ${PERL_TMP_D_HEADER})
    GET_FILENAME_COMPONENT(NAME ${_FILE} NAME)
    SET(OUTFILE ${INC_D}/${NAME})
    ADD_CUSTOM_COMMAND(OUTPUT ${OUTFILE}
      COMMAND ${COPY_CMD} ${_FILE} ${OUTFILE}
      WORKING_DIRECTORY ${OPENSSL_ORIGN_DIR}
      DEPENDS ${OPENSSL_ORIGN_DIR}/${_FILE})
    LIST(APPEND PL_CP_FILES ${OUTFILE})
  ENDFOREACH()
  FOREACH(_FILE ${PERL_INCO_D_HEADER})
    GET_FILENAME_COMPONENT(NAME ${_FILE} NAME)
    SET(OUTFILE ${INCO_D}/${NAME})
    ADD_CUSTOM_COMMAND(OUTPUT ${OUTFILE}
      COMMAND ${COPY_CMD} ${_FILE} ${OUTFILE}
      WORKING_DIRECTORY ${OPENSSL_ORIGN_DIR}
      DEPENDS ${OPENSSL_ORIGN_DIR}/${_FILE})
      LIST(APPEND PL_CP_FILES ${OUTFILE})
  ENDFOREACH()
  ADD_CUSTOM_TARGET(PERL_CP_SCRIPT ALL DEPENDS ${PL_CP_FILES})
  IF(BUILD_SHARED_LIBS)
    # Thsi Perl script for creating "def" files.
    ADD_CUSTOM_COMMAND(OUTPUT ${TMPDLL_D}/${CRYPTO_LIBRARY}.def
      COMMAND ${PERL} util/mkdef.pl 32 libeay > ${TMPDLL_D}/${CRYPTO_LIBRARY}.def
      WORKING_DIRECTORY ${OPENSSL_ORIGN_DIR})
    ADD_CUSTOM_COMMAND(OUTPUT ${TMPDLL_D}/${SSL_LIBRARY}.def
      COMMAND ${PERL} util/mkdef.pl 32 ssleay > ${TMPDLL_D}/${SSL_LIBRARY}.def
      WORKING_DIRECTORY ${OPENSSL_ORIGN_DIR})
  ENDIF(BUILD_SHARED_LIBS)
ENDIF(WIN32)

#-----------------------------------------------------------------------------
# Configuation for header files
#-----------------------------------------------------------------------------
IF(BUILD_SHARED_LIBS)
    INCLUDE_DIRECTORIES(${OPENSSL_ORIGN_DIR}
      ${CMAKE_CURRENT_BINARY_DIR}/${OPENSSL_LIBRARY}
      ${TMPDLL_D} ${INC_D} ${SSL_SRC} ${CRYPTO_SRC})
ELSE()
  INCLUDE_DIRECTORIES(${OPENSSL_ORIGN_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}/${OPENSSL_LIBRARY}
    ${TMP_D} ${INC_D} ${SSL_SRC} ${CRYPTO_SRC})
ENDIF(BUILD_SHARED_LIBS)

#-----------------------------------------------------------------------------
#  openssl. See PerlFileList.cmake
#-----------------------------------------------------------------------------
SET(SSL_SRCS ${SSL_SRC}/s2_meth.c
  ${SSL_SRC}/s2_srvr.c ${SSL_SRC}/s2_clnt.c ${SSL_SRC}/s2_lib.c
  ${SSL_SRC}/s2_enc.c ${SSL_SRC}/s2_pkt.c ${SSL_SRC}/s3_meth.c
  ${SSL_SRC}/s3_srvr.c ${SSL_SRC}/s3_clnt.c ${SSL_SRC}/s3_lib.c
  ${SSL_SRC}/s3_enc.c ${SSL_SRC}/s3_pkt.c ${SSL_SRC}/s3_both.c
  ${SSL_SRC}/s23_meth.c ${SSL_SRC}/s23_srvr.c ${SSL_SRC}/s23_clnt.c
  ${SSL_SRC}/s23_lib.c ${SSL_SRC}/s23_pkt.c ${SSL_SRC}/t1_meth.c
  ${SSL_SRC}/t1_srvr.c ${SSL_SRC}/t1_clnt.c ${SSL_SRC}/t1_lib.c
  ${SSL_SRC}/t1_enc.c ${SSL_SRC}/d1_meth.c ${SSL_SRC}/d1_srvr.c
  ${SSL_SRC}/d1_clnt.c ${SSL_SRC}/d1_lib.c ${SSL_SRC}/d1_pkt.c
  ${SSL_SRC}/d1_both.c ${SSL_SRC}/d1_enc.c ${SSL_SRC}/d1_srtp.c
  ${SSL_SRC}/ssl_lib.c ${SSL_SRC}/ssl_err2.c ${SSL_SRC}/ssl_cert.c
  ${SSL_SRC}/ssl_sess.c ${SSL_SRC}/ssl_ciph.c ${SSL_SRC}/ssl_stat.c
  ${SSL_SRC}/ssl_rsa.c ${SSL_SRC}/ssl_asn1.c ${SSL_SRC}/ssl_txt.c
  ${SSL_SRC}/ssl_algs.c ${SSL_SRC}/bio_ssl.c ${SSL_SRC}/ssl_err.c
  ${SSL_SRC}/kssl.c ${SSL_SRC}/tls_srp.c ${SSL_SRC}/t1_reneg.c
)

SET(CRYPTO_SRCS ${CRYPTO_SRC}/cryptlib.c
  ${CRYPTO_SRC}/mem.c ${CRYPTO_SRC}/mem_dbg.c ${CRYPTO_SRC}/cversion.c
  ${CRYPTO_SRC}/ex_data.c ${CRYPTO_SRC}/cpt_err.c ${CRYPTO_SRC}/ebcdic.c
  ${CRYPTO_SRC}/uid.c ${CRYPTO_SRC}/o_time.c ${CRYPTO_SRC}/o_str.c
  ${CRYPTO_SRC}/o_dir.c ${CRYPTO_SRC}/o_fips.c ${CRYPTO_SRC}/o_init.c
  ${CRYPTO_SRC}/fips_ers.c ${CRYPTO_SRC}/md4/md4_dgst.c ${CRYPTO_SRC}/md4/md4_one.c
  ${CRYPTO_SRC}/md5/md5_dgst.c ${CRYPTO_SRC}/md5/md5_one.c ${CRYPTO_SRC}/sha/sha_dgst.c
  ${CRYPTO_SRC}/sha/sha1dgst.c ${CRYPTO_SRC}/sha/sha_one.c ${CRYPTO_SRC}/sha/sha1_one.c
  ${CRYPTO_SRC}/sha/sha256.c ${CRYPTO_SRC}/sha/sha512.c ${CRYPTO_SRC}/mdc2/mdc2dgst.c
  ${CRYPTO_SRC}/mdc2/mdc2_one.c	${CRYPTO_SRC}/hmac/hmac.c ${CRYPTO_SRC}/hmac/hm_ameth.c
  ${CRYPTO_SRC}/hmac/hm_pmeth.c	${CRYPTO_SRC}/cmac/cmac.c ${CRYPTO_SRC}/cmac/cm_ameth.c
  ${CRYPTO_SRC}/cmac/cm_pmeth.c	${CRYPTO_SRC}/ripemd/rmd_dgst.c ${CRYPTO_SRC}/ripemd/rmd_one.c
  ${CRYPTO_SRC}/des/set_key.c ${CRYPTO_SRC}/des/ecb_enc.c ${CRYPTO_SRC}/des/cbc_enc.c
  ${CRYPTO_SRC}/des/ecb3_enc.c ${CRYPTO_SRC}/des/cfb64enc.c ${CRYPTO_SRC}/des/cfb64ede.c
  ${CRYPTO_SRC}/des/cfb_enc.c ${CRYPTO_SRC}/des/ofb64ede.c ${CRYPTO_SRC}/des/enc_read.c
  ${CRYPTO_SRC}/des/enc_writ.c ${CRYPTO_SRC}/des/ofb64enc.c ${CRYPTO_SRC}/des/ofb_enc.c
  ${CRYPTO_SRC}/des/str2key.c ${CRYPTO_SRC}/des/pcbc_enc.c ${CRYPTO_SRC}/des/qud_cksm.c
  ${CRYPTO_SRC}/des/rand_key.c ${CRYPTO_SRC}/des/fcrypt.c ${CRYPTO_SRC}/des/xcbc_enc.c
  ${CRYPTO_SRC}/des/rpc_enc.c ${CRYPTO_SRC}/des/cbc_cksm.c ${CRYPTO_SRC}/des/ede_cbcm_enc.c
  ${CRYPTO_SRC}/des/des_old.c	${CRYPTO_SRC}/des/des_old2.c ${CRYPTO_SRC}/des/read2pwd.c
  ${CRYPTO_SRC}/rc2/rc2_ecb.c	${CRYPTO_SRC}/rc2/rc2_skey.c ${CRYPTO_SRC}/rc2/rc2_cbc.c
  ${CRYPTO_SRC}/rc2/rc2cfb64.c ${CRYPTO_SRC}/rc2/rc2ofb64.c ${CRYPTO_SRC}/rc4/rc4_utl.c
  ${CRYPTO_SRC}/idea/i_cbc.c ${CRYPTO_SRC}/idea/i_cfb64.c ${CRYPTO_SRC}/idea/i_ofb64.c
  ${CRYPTO_SRC}/idea/i_ecb.c ${CRYPTO_SRC}/idea/i_skey.c ${CRYPTO_SRC}/bf/bf_skey.c
  ${CRYPTO_SRC}/bf/bf_ecb.c  ${CRYPTO_SRC}/bf/bf_cfb64.c ${CRYPTO_SRC}/bf/bf_ofb64.c
  ${CRYPTO_SRC}/cast/c_skey.c ${CRYPTO_SRC}/cast/c_ecb.c ${CRYPTO_SRC}/cast/c_cfb64.c
  ${CRYPTO_SRC}/cast/c_ofb64.c ${CRYPTO_SRC}/aes/aes_misc.c ${CRYPTO_SRC}/aes/aes_ecb.c
  ${CRYPTO_SRC}/aes/aes_cfb.c ${CRYPTO_SRC}/aes/aes_ofb.c ${CRYPTO_SRC}/aes/aes_ctr.c
  ${CRYPTO_SRC}/aes/aes_ige.c ${CRYPTO_SRC}/aes/aes_wrap.c ${CRYPTO_SRC}/camellia/cmll_ecb.c
  ${CRYPTO_SRC}/camellia/cmll_ofb.c	${CRYPTO_SRC}/camellia/cmll_cfb.c ${CRYPTO_SRC}/camellia/cmll_ctr.c
  ${CRYPTO_SRC}/camellia/cmll_utl.c	${CRYPTO_SRC}/seed/seed.c ${CRYPTO_SRC}/seed/seed_ecb.c
  ${CRYPTO_SRC}/seed/seed_cbc.c ${CRYPTO_SRC}/seed/seed_cfb.c ${CRYPTO_SRC}/seed/seed_ofb.c
  ${CRYPTO_SRC}/modes/cbc128.c ${CRYPTO_SRC}/modes/ctr128.c ${CRYPTO_SRC}/modes/cts128.c
  ${CRYPTO_SRC}/modes/cfb128.c ${CRYPTO_SRC}/modes/ofb128.c ${CRYPTO_SRC}/modes/gcm128.c
  ${CRYPTO_SRC}/modes/ccm128.c ${CRYPTO_SRC}/modes/xts128.c ${CRYPTO_SRC}/bn/bn_add.c
  ${CRYPTO_SRC}/bn/bn_div.c ${CRYPTO_SRC}/bn/bn_exp.c	${CRYPTO_SRC}/bn/bn_lib.c
  ${CRYPTO_SRC}/bn/bn_ctx.c ${CRYPTO_SRC}/bn/bn_mul.c	${CRYPTO_SRC}/bn/bn_mod.c
  ${CRYPTO_SRC}/bn/bn_print.c ${CRYPTO_SRC}/bn/bn_rand.c ${CRYPTO_SRC}/bn/bn_shift.c
  ${CRYPTO_SRC}/bn/bn_word.c ${CRYPTO_SRC}/bn/bn_blind.c ${CRYPTO_SRC}/bn/bn_kron.c
  ${CRYPTO_SRC}/bn/bn_sqrt.c ${CRYPTO_SRC}/bn/bn_gcd.c ${CRYPTO_SRC}/bn/bn_prime.c
  ${CRYPTO_SRC}/bn/bn_err.c ${CRYPTO_SRC}/bn/bn_sqr.c ${CRYPTO_SRC}/bn/bn_recp.c
  ${CRYPTO_SRC}/bn/bn_mont.c ${CRYPTO_SRC}/bn/bn_mpi.c ${CRYPTO_SRC}/bn/bn_exp2.c
  ${CRYPTO_SRC}/bn/bn_gf2m.c ${CRYPTO_SRC}/bn/bn_nist.c ${CRYPTO_SRC}/bn/bn_depr.c
  ${CRYPTO_SRC}/bn/bn_const.c	${CRYPTO_SRC}/bn/bn_x931p.c ${CRYPTO_SRC}/rsa/rsa_eay.c
  ${CRYPTO_SRC}/rsa/rsa_gen.c	${CRYPTO_SRC}/rsa/rsa_lib.c ${CRYPTO_SRC}/rsa/rsa_sign.c
  ${CRYPTO_SRC}/rsa/rsa_saos.c ${CRYPTO_SRC}/rsa/rsa_err.c ${CRYPTO_SRC}/rsa/rsa_pk1.c
  ${CRYPTO_SRC}/rsa/rsa_ssl.c	${CRYPTO_SRC}/rsa/rsa_none.c ${CRYPTO_SRC}/rsa/rsa_oaep.c
  ${CRYPTO_SRC}/rsa/rsa_chk.c	${CRYPTO_SRC}/rsa/rsa_null.c ${CRYPTO_SRC}/rsa/rsa_pss.c
  ${CRYPTO_SRC}/rsa/rsa_x931.c ${CRYPTO_SRC}/rsa/rsa_asn1.c ${CRYPTO_SRC}/rsa/rsa_depr.c
  ${CRYPTO_SRC}/rsa/rsa_ameth.c ${CRYPTO_SRC}/rsa/rsa_prn.c ${CRYPTO_SRC}/rsa/rsa_pmeth.c
  ${CRYPTO_SRC}/rsa/rsa_crpt.c ${CRYPTO_SRC}/dsa/dsa_gen.c ${CRYPTO_SRC}/dsa/dsa_key.c
  ${CRYPTO_SRC}/dsa/dsa_lib.c ${CRYPTO_SRC}/dsa/dsa_asn1.c ${CRYPTO_SRC}/dsa/dsa_vrf.c
  ${CRYPTO_SRC}/dsa/dsa_sign.c ${CRYPTO_SRC}/dsa/dsa_err.c ${CRYPTO_SRC}/dsa/dsa_ossl.c
  ${CRYPTO_SRC}/dsa/dsa_depr.c ${CRYPTO_SRC}/dsa/dsa_ameth.c ${CRYPTO_SRC}/dsa/dsa_pmeth.c
  ${CRYPTO_SRC}/dsa/dsa_prn.c	${CRYPTO_SRC}/dso/dso_dl.c ${CRYPTO_SRC}/dso/dso_dlfcn.c
  ${CRYPTO_SRC}/dso/dso_err.c	${CRYPTO_SRC}/dso/dso_lib.c ${CRYPTO_SRC}/dso/dso_null.c
  ${CRYPTO_SRC}/dso/dso_openssl.c	${CRYPTO_SRC}/dso/dso_win32.c ${CRYPTO_SRC}/dso/dso_vms.c
  ${CRYPTO_SRC}/dso/dso_beos.c ${CRYPTO_SRC}/dh/dh_asn1.c ${CRYPTO_SRC}/dh/dh_gen.c
  ${CRYPTO_SRC}/dh/dh_key.c ${CRYPTO_SRC}/dh/dh_lib.c ${CRYPTO_SRC}/dh/dh_check.c
  ${CRYPTO_SRC}/dh/dh_err.c	${CRYPTO_SRC}/dh/dh_depr.c ${CRYPTO_SRC}/dh/dh_ameth.c
  ${CRYPTO_SRC}/dh/dh_pmeth.c	${CRYPTO_SRC}/dh/dh_prn.c ${CRYPTO_SRC}/ec/ec_lib.c
  ${CRYPTO_SRC}/ec/ecp_smpl.c	${CRYPTO_SRC}/ec/ecp_mont.c ${CRYPTO_SRC}/ec/ecp_nist.c
  ${CRYPTO_SRC}/ec/ec_cvt.c	${CRYPTO_SRC}/ec/ec_mult.c ${CRYPTO_SRC}/ec/ec_err.c
  ${CRYPTO_SRC}/ec/ec_curve.c	${CRYPTO_SRC}/ec/ec_check.c ${CRYPTO_SRC}/ec/ec_print.c
  ${CRYPTO_SRC}/ec/ec_asn1.c ${CRYPTO_SRC}/ec/ec_key.c ${CRYPTO_SRC}/ec/ec2_smpl.c
  ${CRYPTO_SRC}/ec/ec2_mult.c	${CRYPTO_SRC}/ec/ec_ameth.c ${CRYPTO_SRC}/ec/ec_pmeth.c
  ${CRYPTO_SRC}/ec/eck_prn.c ${CRYPTO_SRC}/ec/ecp_nistp224.c ${CRYPTO_SRC}/ec/ecp_nistp256.c
  ${CRYPTO_SRC}/ec/ecp_nistp521.c	${CRYPTO_SRC}/ec/ecp_nistputil.c ${CRYPTO_SRC}/ec/ecp_oct.c
  ${CRYPTO_SRC}/ec/ec2_oct.c ${CRYPTO_SRC}/ec/ec_oct.c ${CRYPTO_SRC}/ecdh/ech_lib.c
  ${CRYPTO_SRC}/ecdh/ech_ossl.c	${CRYPTO_SRC}/ecdh/ech_key.c ${CRYPTO_SRC}/ecdh/ech_err.c
  ${CRYPTO_SRC}/ecdsa/ecs_lib.c	${CRYPTO_SRC}/ecdsa/ecs_asn1.c ${CRYPTO_SRC}/ecdsa/ecs_ossl.c
  ${CRYPTO_SRC}/ecdsa/ecs_sign.c ${CRYPTO_SRC}/ecdsa/ecs_vrf.c ${CRYPTO_SRC}/ecdsa/ecs_err.c
  ${CRYPTO_SRC}/buffer/buffer.c	${CRYPTO_SRC}/buffer/buf_str.c ${CRYPTO_SRC}/buffer/buf_err.c
  ${CRYPTO_SRC}/bio/bio_lib.c	${CRYPTO_SRC}/bio/bio_cb.c ${CRYPTO_SRC}/bio/bio_err.c
  ${CRYPTO_SRC}/bio/bss_mem.c	${CRYPTO_SRC}/bio/bss_null.c ${CRYPTO_SRC}/bio/bss_fd.c
  ${CRYPTO_SRC}/bio/bss_file.c ${CRYPTO_SRC}/bio/bss_sock.c ${CRYPTO_SRC}/bio/bss_conn.c
  ${CRYPTO_SRC}/bio/bf_null.c	${CRYPTO_SRC}/bio/bf_buff.c ${CRYPTO_SRC}//bio/b_print.c
  ${CRYPTO_SRC}//bio/b_dump.c	${CRYPTO_SRC}//bio/b_sock.c ${CRYPTO_SRC}//bio/bss_acpt.c
  ${CRYPTO_SRC}//bio/bf_nbio.c ${CRYPTO_SRC}//bio/bss_log.c ${CRYPTO_SRC}//bio/bss_bio.c
  ${CRYPTO_SRC}//bio/bss_dgram.c ${CRYPTO_SRC}/stack/stack.c ${CRYPTO_SRC}/lhash/lhash.c
  ${CRYPTO_SRC}/lhash/lh_stats.c ${CRYPTO_SRC}/rand/md_rand.c ${CRYPTO_SRC}/rand/randfile.c
  ${CRYPTO_SRC}/rand/rand_lib.c	${CRYPTO_SRC}/rand/rand_err.c ${CRYPTO_SRC}/rand/rand_egd.c
  ${CRYPTO_SRC}/rand/rand_win.c	${CRYPTO_SRC}/rand/rand_unix.c ${CRYPTO_SRC}/rand/rand_os2.c
  ${CRYPTO_SRC}/rand/rand_nw.c ${CRYPTO_SRC}/err/err.c ${CRYPTO_SRC}/err/err_all.c
  ${CRYPTO_SRC}/err/err_prn.c	${CRYPTO_SRC}/objects/o_names.c ${CRYPTO_SRC}/objects/obj_dat.c
  ${CRYPTO_SRC}/objects/obj_lib.c	${CRYPTO_SRC}/objects/obj_err.c ${CRYPTO_SRC}/objects/obj_xref.c
  ${CRYPTO_SRC}/evp/encode.c ${CRYPTO_SRC}/evp/digest.c ${CRYPTO_SRC}/evp/evp_enc.c
  ${CRYPTO_SRC}/evp/evp_key.c	${CRYPTO_SRC}/evp/evp_acnf.c ${CRYPTO_SRC}/evp/e_des.c
  ${CRYPTO_SRC}/evp/e_bf.c ${CRYPTO_SRC}/evp/e_idea.c ${CRYPTO_SRC}/evp/e_des3.c
  ${CRYPTO_SRC}/evp/e_camellia.c ${CRYPTO_SRC}/evp/e_rc4.c ${CRYPTO_SRC}/evp/e_aes.c
  ${CRYPTO_SRC}/evp/names.c ${CRYPTO_SRC}/evp/e_seed.c ${CRYPTO_SRC}/evp/e_xcbc_d.c
  ${CRYPTO_SRC}/evp/e_rc2.c	${CRYPTO_SRC}/evp/e_cast.c ${CRYPTO_SRC}/evp/e_rc5.c
  ${CRYPTO_SRC}/evp/m_null.c ${CRYPTO_SRC}/evp/m_md4.c ${CRYPTO_SRC}/evp/m_md5.c
  ${CRYPTO_SRC}/evp/m_sha.c	${CRYPTO_SRC}/evp/m_sha1.c ${CRYPTO_SRC}/evp/m_wp.c
  ${CRYPTO_SRC}/evp/m_dss.c	${CRYPTO_SRC}/evp/m_dss1.c ${CRYPTO_SRC}/evp/m_mdc2.c
  ${CRYPTO_SRC}/evp/m_ripemd.c ${CRYPTO_SRC}/evp/m_ecdsa.c ${CRYPTO_SRC}/evp/p_open.c
  ${CRYPTO_SRC}/evp/p_seal.c ${CRYPTO_SRC}/evp/p_sign.c ${CRYPTO_SRC}/evp/p_verify.c
  ${CRYPTO_SRC}/evp/p_lib.c ${CRYPTO_SRC}/evp/p_enc.c ${CRYPTO_SRC}/evp/p_dec.c
  ${CRYPTO_SRC}/evp/bio_md.c ${CRYPTO_SRC}/evp/bio_b64.c ${CRYPTO_SRC}/evp/bio_enc.c
  ${CRYPTO_SRC}/evp/evp_err.c	${CRYPTO_SRC}/evp/e_null.c ${CRYPTO_SRC}/evp/c_all.c
  ${CRYPTO_SRC}/evp/c_allc.c ${CRYPTO_SRC}/evp/c_alld.c ${CRYPTO_SRC}/evp/evp_lib.c
  ${CRYPTO_SRC}/evp/bio_ok.c ${CRYPTO_SRC}/evp/evp_pkey.c ${CRYPTO_SRC}/evp/evp_pbe.c
  ${CRYPTO_SRC}/evp/p5_crpt.c	${CRYPTO_SRC}/evp/p5_crpt2.c ${CRYPTO_SRC}/evp/e_old.c
  ${CRYPTO_SRC}/evp/pmeth_lib.c	${CRYPTO_SRC}/evp/pmeth_fn.c ${CRYPTO_SRC}/evp/pmeth_gn.c
  ${CRYPTO_SRC}/evp/m_sigver.c ${CRYPTO_SRC}/evp/evp_fips.c ${CRYPTO_SRC}/evp/e_aes_cbc_hmac_sha1.c
  ${CRYPTO_SRC}/evp/e_rc4_hmac_md5.c ${CRYPTO_SRC}/asn1/a_object.c ${CRYPTO_SRC}/asn1/a_bitstr.c
  ${CRYPTO_SRC}/asn1/a_utctm.c ${CRYPTO_SRC}/asn1/a_gentm.c ${CRYPTO_SRC}/asn1/a_time.c
  ${CRYPTO_SRC}/asn1/a_int.c ${CRYPTO_SRC}/asn1/a_octet.c ${CRYPTO_SRC}/asn1/a_print.c
  ${CRYPTO_SRC}/asn1/a_type.c	${CRYPTO_SRC}/asn1/a_set.c ${CRYPTO_SRC}/asn1/a_dup.c
  ${CRYPTO_SRC}/asn1/a_d2i_fp.c	${CRYPTO_SRC}/asn1/a_i2d_fp.c ${CRYPTO_SRC}/asn1/a_enum.c
  ${CRYPTO_SRC}/asn1/a_utf8.c	${CRYPTO_SRC}/asn1/a_sign.c ${CRYPTO_SRC}/asn1/a_digest.c
  ${CRYPTO_SRC}/asn1/a_verify.c	${CRYPTO_SRC}/asn1/a_mbstr.c ${CRYPTO_SRC}/asn1/a_strex.c
  ${CRYPTO_SRC}/asn1/x_algor.c ${CRYPTO_SRC}/asn1/x_val.c ${CRYPTO_SRC}/asn1/x_pubkey.c
  ${CRYPTO_SRC}/asn1/x_sig.c ${CRYPTO_SRC}/asn1/x_req.c ${CRYPTO_SRC}/asn1/x_attrib.c
  ${CRYPTO_SRC}/asn1/x_bignum.c ${CRYPTO_SRC}/asn1/x_long.c ${CRYPTO_SRC}/asn1/x_name.c
  ${CRYPTO_SRC}/asn1/x_x509.c ${CRYPTO_SRC}/asn1/x_x509a.c ${CRYPTO_SRC}/asn1/x_crl.c
  ${CRYPTO_SRC}/asn1/x_info.c ${CRYPTO_SRC}/asn1/x_spki.c ${CRYPTO_SRC}/asn1/nsseq.c
  ${CRYPTO_SRC}/asn1/x_nx509.c ${CRYPTO_SRC}/asn1/d2i_pu.c ${CRYPTO_SRC}/asn1/d2i_pr.c
  ${CRYPTO_SRC}/asn1/i2d_pu.c ${CRYPTO_SRC}/asn1/i2d_pr.c ${CRYPTO_SRC}/asn1/t_req.c
  ${CRYPTO_SRC}/asn1/t_x509.c ${CRYPTO_SRC}/asn1/t_x509a.c ${CRYPTO_SRC}/asn1/t_crl.c
  ${CRYPTO_SRC}/asn1/t_pkey.c ${CRYPTO_SRC}/asn1/t_spki.c ${CRYPTO_SRC}/asn1/t_bitst.c
  ${CRYPTO_SRC}/asn1/tasn_new.c ${CRYPTO_SRC}/asn1/tasn_fre.c ${CRYPTO_SRC}/asn1/tasn_enc.c
  ${CRYPTO_SRC}/asn1/tasn_dec.c ${CRYPTO_SRC}/asn1/tasn_utl.c ${CRYPTO_SRC}/asn1/tasn_typ.c
  ${CRYPTO_SRC}/asn1/tasn_prn.c ${CRYPTO_SRC}/asn1/ameth_lib.c ${CRYPTO_SRC}/asn1/f_int.c
  ${CRYPTO_SRC}/asn1/f_string.c ${CRYPTO_SRC}/asn1/n_pkey.c ${CRYPTO_SRC}/asn1/f_enum.c
  ${CRYPTO_SRC}/asn1/x_pkey.c ${CRYPTO_SRC}/asn1/a_bool.c ${CRYPTO_SRC}/asn1/x_exten.c
  ${CRYPTO_SRC}/asn1/bio_asn1.c ${CRYPTO_SRC}/asn1/bio_ndef.c ${CRYPTO_SRC}/asn1/asn_mime.c
  ${CRYPTO_SRC}/asn1/asn1_gen.c ${CRYPTO_SRC}/asn1/asn1_par.c ${CRYPTO_SRC}/asn1/asn1_lib.c
  ${CRYPTO_SRC}/asn1/asn1_err.c ${CRYPTO_SRC}/asn1/a_bytes.c ${CRYPTO_SRC}/asn1/a_strnid.c
  ${CRYPTO_SRC}/asn1/evp_asn1.c ${CRYPTO_SRC}/asn1/asn_pack.c ${CRYPTO_SRC}/asn1/p5_pbe.c
  ${CRYPTO_SRC}/asn1/p5_pbev2.c ${CRYPTO_SRC}/asn1/p8_pkey.c ${CRYPTO_SRC}/asn1/asn_moid.c
  ${CRYPTO_SRC}/pem/pem_sign.c ${CRYPTO_SRC}/pem/pem_seal.c ${CRYPTO_SRC}/pem/pem_info.c
  ${CRYPTO_SRC}/pem/pem_lib.c ${CRYPTO_SRC}/pem/pem_all.c ${CRYPTO_SRC}/pem/pem_err.c
  ${CRYPTO_SRC}/pem/pem_x509.c ${CRYPTO_SRC}/pem/pem_xaux.c ${CRYPTO_SRC}/pem/pem_oth.c
  ${CRYPTO_SRC}/pem/pem_pk8.c ${CRYPTO_SRC}/pem/pem_pkey.c ${CRYPTO_SRC}/pem/pvkfmt.c
  ${CRYPTO_SRC}/x509/x509_def.c ${CRYPTO_SRC}/x509/x509_d2.c ${CRYPTO_SRC}/x509/x509_r2x.c
  ${CRYPTO_SRC}/x509/x509_cmp.c ${CRYPTO_SRC}/x509/x509_obj.c ${CRYPTO_SRC}/x509/x509_req.c
  ${CRYPTO_SRC}/x509/x509spki.c ${CRYPTO_SRC}/x509/x509_vfy.c ${CRYPTO_SRC}/x509/x509_set.c
  ${CRYPTO_SRC}/x509/x509cset.c ${CRYPTO_SRC}/x509/x509rset.c ${CRYPTO_SRC}/x509/x509_err.c
  ${CRYPTO_SRC}/x509/x509name.c ${CRYPTO_SRC}/x509/x509_v3.c ${CRYPTO_SRC}/x509/x509_ext.c
  ${CRYPTO_SRC}/x509/x509_att.c ${CRYPTO_SRC}/x509/x509type.c ${CRYPTO_SRC}/x509/x509_lu.c
  ${CRYPTO_SRC}/x509/x_all.c ${CRYPTO_SRC}/x509/x509_txt.c ${CRYPTO_SRC}/x509/x509_trs.c
  ${CRYPTO_SRC}/x509/by_file.c ${CRYPTO_SRC}/x509/by_dir.c ${CRYPTO_SRC}/x509/x509_vpm.c
  ${CRYPTO_SRC}/x509v3/v3_bcons.c ${CRYPTO_SRC}/x509v3/v3_bitst.c ${CRYPTO_SRC}/x509v3/v3_conf.c
  ${CRYPTO_SRC}/x509v3/v3_extku.c ${CRYPTO_SRC}/x509v3/v3_ia5.c ${CRYPTO_SRC}/x509v3/v3_lib.c
  ${CRYPTO_SRC}/x509v3/v3_prn.c ${CRYPTO_SRC}/x509v3/v3_utl.c ${CRYPTO_SRC}/x509v3/v3err.c
  ${CRYPTO_SRC}/x509v3/v3_genn.c ${CRYPTO_SRC}/x509v3/v3_alt.c ${CRYPTO_SRC}/x509v3/v3_skey.c
  ${CRYPTO_SRC}/x509v3/v3_akey.c ${CRYPTO_SRC}/x509v3/v3_pku.c ${CRYPTO_SRC}/x509v3/v3_int.c
  ${CRYPTO_SRC}/x509v3/v3_enum.c ${CRYPTO_SRC}/x509v3/v3_sxnet.c ${CRYPTO_SRC}/x509v3/v3_cpols.c
  ${CRYPTO_SRC}/x509v3/v3_crld.c  ${CRYPTO_SRC}/x509v3/v3_purp.c ${CRYPTO_SRC}/x509v3/v3_info.c
  ${CRYPTO_SRC}/x509v3/v3_ocsp.c ${CRYPTO_SRC}/x509v3/v3_akeya.c ${CRYPTO_SRC}/x509v3/v3_pmaps.c
  ${CRYPTO_SRC}/x509v3/v3_pcons.c ${CRYPTO_SRC}/x509v3/v3_ncons.c ${CRYPTO_SRC}/x509v3/v3_pcia.c
  ${CRYPTO_SRC}/x509v3/v3_pci.c ${CRYPTO_SRC}/x509v3/pcy_cache.c ${CRYPTO_SRC}/x509v3/pcy_node.c
  ${CRYPTO_SRC}/x509v3/pcy_data.c ${CRYPTO_SRC}/x509v3/pcy_map.c ${CRYPTO_SRC}/x509v3/pcy_tree.c
  ${CRYPTO_SRC}/x509v3/pcy_lib.c ${CRYPTO_SRC}/x509v3/v3_asid.c ${CRYPTO_SRC}/x509v3/v3_addr.c
  ${CRYPTO_SRC}/cms/cms_lib.c ${CRYPTO_SRC}/cms/cms_asn1.c ${CRYPTO_SRC}/cms/cms_att.c
  ${CRYPTO_SRC}/cms/cms_io.c ${CRYPTO_SRC}/cms/cms_smime.c ${CRYPTO_SRC}/cms/cms_err.c
  ${CRYPTO_SRC}/cms/cms_sd.c ${CRYPTO_SRC}/cms/cms_dd.c ${CRYPTO_SRC}/cms/cms_cd.c
  ${CRYPTO_SRC}/cms/cms_env.c ${CRYPTO_SRC}/cms/cms_enc.c ${CRYPTO_SRC}/cms/cms_ess.c
  ${CRYPTO_SRC}/cms/cms_pwri.c ${CRYPTO_SRC}/conf/conf_err.c ${CRYPTO_SRC}/conf/conf_lib.c
  ${CRYPTO_SRC}/conf/conf_api.c ${CRYPTO_SRC}/conf/conf_def.c ${CRYPTO_SRC}/conf/conf_mod.c
  ${CRYPTO_SRC}/conf/conf_mall.c ${CRYPTO_SRC}/conf/conf_sap.c ${CRYPTO_SRC}/txt_db/txt_db.c
  ${CRYPTO_SRC}/pkcs7/pk7_asn1.c ${CRYPTO_SRC}/pkcs7/pk7_lib.c ${CRYPTO_SRC}/pkcs7/pkcs7err.c
  ${CRYPTO_SRC}/pkcs7/pk7_doit.c ${CRYPTO_SRC}/pkcs7/pk7_smime.c ${CRYPTO_SRC}/pkcs7/pk7_attr.c
  ${CRYPTO_SRC}/pkcs7/pk7_mime.c ${CRYPTO_SRC}/pkcs7/bio_pk7.c ${CRYPTO_SRC}/pkcs12/p12_add.c
  ${CRYPTO_SRC}/pkcs12/p12_asn.c ${CRYPTO_SRC}/pkcs12/p12_attr.c ${CRYPTO_SRC}/pkcs12/p12_crpt.c
  ${CRYPTO_SRC}/pkcs12/p12_crt.c ${CRYPTO_SRC}/pkcs12/p12_decr.c ${CRYPTO_SRC}/pkcs12/p12_init.c
  ${CRYPTO_SRC}/pkcs12/p12_key.c ${CRYPTO_SRC}/pkcs12/p12_kiss.c ${CRYPTO_SRC}/pkcs12/p12_mutl.c
  ${CRYPTO_SRC}/pkcs12/p12_utl.c ${CRYPTO_SRC}/pkcs12/p12_npas.c ${CRYPTO_SRC}/pkcs12/pk12err.c
  ${CRYPTO_SRC}/pkcs12/p12_p8d.c ${CRYPTO_SRC}/pkcs12/p12_p8e.c ${CRYPTO_SRC}/comp/comp_lib.c
  ${CRYPTO_SRC}/comp/comp_err.c ${CRYPTO_SRC}/comp/c_rle.c ${CRYPTO_SRC}/comp/c_zlib.c
  ${CRYPTO_SRC}/engine/eng_err.c ${CRYPTO_SRC}/engine/eng_lib.c ${CRYPTO_SRC}/engine/eng_list.c
  ${CRYPTO_SRC}/engine/eng_init.c ${CRYPTO_SRC}/engine/eng_ctrl.c ${CRYPTO_SRC}/engine/eng_table.c
  ${CRYPTO_SRC}/engine/eng_pkey.c ${CRYPTO_SRC}/engine/eng_fat.c ${CRYPTO_SRC}/engine/eng_all.c
  ${CRYPTO_SRC}/engine/tb_rsa.c ${CRYPTO_SRC}/engine/tb_dsa.c ${CRYPTO_SRC}/engine/tb_ecdsa.c
  ${CRYPTO_SRC}/engine/tb_dh.c ${CRYPTO_SRC}/engine/tb_ecdh.c ${CRYPTO_SRC}/engine/tb_rand.c
  ${CRYPTO_SRC}/engine/tb_store.c ${CRYPTO_SRC}/engine/tb_cipher.c ${CRYPTO_SRC}/engine/tb_digest.c
  ${CRYPTO_SRC}/engine/tb_pkmeth.c ${CRYPTO_SRC}/engine/tb_asnmth.c ${CRYPTO_SRC}/engine/eng_openssl.c
  ${CRYPTO_SRC}/engine/eng_cnf.c ${CRYPTO_SRC}/engine/eng_dyn.c ${CRYPTO_SRC}/engine/eng_cryptodev.c
  ${CRYPTO_SRC}/engine/eng_rsax.c ${CRYPTO_SRC}/engine/eng_rdrand.c ${CRYPTO_SRC}/ocsp/ocsp_asn.c
  ${CRYPTO_SRC}/ocsp/ocsp_ext.c ${CRYPTO_SRC}/ocsp/ocsp_ht.c ${CRYPTO_SRC}/ocsp/ocsp_lib.c
  ${CRYPTO_SRC}/ocsp/ocsp_cl.c ${CRYPTO_SRC}/ocsp/ocsp_srv.c ${CRYPTO_SRC}/ocsp/ocsp_prn.c
  ${CRYPTO_SRC}/ocsp/ocsp_vfy.c ${CRYPTO_SRC}/ocsp/ocsp_err.c ${CRYPTO_SRC}/ui/ui_err.c
  ${CRYPTO_SRC}/ui/ui_lib.c ${CRYPTO_SRC}/ui/ui_openssl.c ${CRYPTO_SRC}/ui/ui_util.c
  ${CRYPTO_SRC}/ui/ui_compat.c ${CRYPTO_SRC}/krb5/krb5_asn.c ${CRYPTO_SRC}/pqueue/pqueue.c
  ${CRYPTO_SRC}/whrlpool/wp_dgst.c ${CRYPTO_SRC}/whrlpool/wp_block.c ${CRYPTO_SRC}/ts/ts_err.c
  ${CRYPTO_SRC}/ts/ts_req_utils.c ${CRYPTO_SRC}/ts/ts_req_print.c ${CRYPTO_SRC}/ts/ts_rsp_utils.c
  ${CRYPTO_SRC}/ts/ts_rsp_print.c ${CRYPTO_SRC}/ts/ts_rsp_sign.c ${CRYPTO_SRC}/ts/ts_rsp_verify.c
  ${CRYPTO_SRC}/ts/ts_verify_ctx.c ${CRYPTO_SRC}/ts/ts_lib.c ${CRYPTO_SRC}/ts/ts_conf.c
  ${CRYPTO_SRC}/ts/ts_asn1.c ${CRYPTO_SRC}/srp/srp_lib.c ${CRYPTO_SRC}/srp/srp_vfy.c
)

SET(GOST_SRCS ${ENGS_SRC}/ccgost/e_gost_err.c
  ${ENGS_SRC}/ccgost/gost2001_keyx.c ${ENGS_SRC}/ccgost/gost2001.c ${ENGS_SRC}/ccgost/gost89.c
  ${ENGS_SRC}/ccgost/gost94_keyx.c ${ENGS_SRC}/ccgost/gost_ameth.c ${ENGS_SRC}/ccgost/gost_asn1.c
  ${ENGS_SRC}/ccgost/gost_crypt.c ${ENGS_SRC}/ccgost/gost_ctl.c ${ENGS_SRC}/ccgost/gost_eng.c
  ${ENGS_SRC}/ccgost/gosthash.c ${ENGS_SRC}/ccgost/gost_keywrap.c ${ENGS_SRC}/ccgost/gost_md.c
  ${ENGS_SRC}/ccgost/gost_params.c ${ENGS_SRC}/ccgost/gost_pmeth.c ${ENGS_SRC}/ccgost/gost_sign.c
)

SET(NO_ASM_FILE_LIST ${CRYPTO_SRC}/camellia/cmll_cbc.c
  ${CRYPTO_SRC}/mem_clr.c  ${CRYPTO_SRC}/bn/bn_asm.c ${CRYPTO_SRC}/des/des_enc.c
  ${CRYPTO_SRC}/des/fcrypt_b.c ${CRYPTO_SRC}/aes/aes_core.c ${CRYPTO_SRC}/aes/aes_cbc.c
  ${CRYPTO_SRC}/bf/bf_enc.c ${CRYPTO_SRC}/cast/c_enc.c ${CRYPTO_SRC}/rc4/rc4_enc.c
  ${CRYPTO_SRC}/rc4/rc4_skey.c ${CRYPTO_SRC}/camellia/camellia.c ${CRYPTO_SRC}/camellia/cmll_misc.c
)

#-----------------------------------------------------------------------------
# Configure for library
#-----------------------------------------------------------------------------
IF(BUILD_SHARED_LIBS)
  ADD_LIBRARY(${CRYPTO_LIBRARY} SHARED ${CRYPTO_SRCS} ${GOST_SRCS} ${NO_ASM_FILE_LIST} ${TMPDLL_D}/${CRYPTO_LIBRARY}.def)
  ADD_LIBRARY(${SSL_LIBRARY} SHARED ${SSL_SRCS} ${TMPDLL_D}/${SSL_LIBRARY}.def)
  SET_TARGET_PROPERTIES(${CRYPTO_LIBRARY} PROPERTIES DEFINE_SYMBOL "OPENSSL_BUILD_SHLIBCRYPTO")
  SET_TARGET_PROPERTIES(${SSL_LIBRARY} PROPERTIES DEFINE_SYMBOL "OPENSSL_BUILD_SHLIBCSSL")
ELSE(BUILD_SHARED_LIBS)
  ADD_LIBRARY(${CRYPTO_LIBRARY} STATIC ${CRYPTO_SRCS} ${GOST_SRCS} ${NO_ASM_FILE_LIST})
  ADD_LIBRARY(${SSL_LIBRARY} STATIC ${SSL_SRCS})
ENDIF(BUILD_SHARED_LIBS)
# link the Perl script targets to libraries
ADD_DEPENDENCIES(${CRYPTO_LIBRARY} PERL_CP_SCRIPT)
ADD_DEPENDENCIES(${SSL_LIBRARY} PERL_CP_SCRIPT)
TARGET_LINK_LIBRARIES(${CRYPTO_LIBRARY} ${WIN32_LIBRARIES})
TARGET_LINK_LIBRARIES(${SSL_LIBRARY} ${WIN32_LIBRARIES} ${CRYPTO_LIBRARY})

#-----------------------------------------------------------------------------
# Installation
#-----------------------------------------------------------------------------
IF(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL)
  INSTALL(DIRECTORY ${INCO_D} DESTINATION ${DCMTK_INSTALL_INCDIR} FILES_MATCHING PATTERN "*.h")
ENDIF()
