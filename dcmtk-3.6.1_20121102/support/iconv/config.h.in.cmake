/* Copyright (C) 1999-2003, 2005, 2007, 2010 Free Software Foundation, Inc.
   This file is part of the GNU LIBICONV Library.

   The GNU LIBICONV Library is free software you can redistribute it
   and/or modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation either version 2
   of the License, or (at your option) any later version.

   The GNU LIBICONV Library is distributed in the hope that it will be
   useful, but WITHOUT ANY WARRANTY without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with the GNU LIBICONV Library see the file COPYING.LIB.
   If not, write to the Free Software Foundation, Inc., 51 Franklin Street,
   Fifth Floor, Boston, MA 02110-1301, USA.  */


#cmakedefine BUILDING_LIBICONV  @BUILDING_LIBICONV@

/* Define to 1 to enable a few rarely used encodings. */
#cmakedefine ENABLE_EXTRA  @ENABLE_EXTRA@

/* Define to 1 if the package shall run at any location in the filesystem. */
#cmakedefine ENABLE_RELOCATABLE @ENABLE_RELOCATABLE@

/* Define to a type if <wchar.h> does not define. */
#cmakedefine mbstate_t @mbstate_t@

/* Define if you have <iconv.h>, the iconv_t type, and the
   iconv_open, iconv, iconv_close functions. */
#cmakedefine HAVE_ICONV @HAVE_ICONV@
/* Define as const if the declaration of iconv() needs const. */
#define ICONV_CONST /* empty by default */

/* Define to 1 if you have the getc_unlocked() function. */
#cmakedefine HAVE_GETC_UNLOCKED @HAVE_GETC_UNLOCKED@

/* Define if you have <langinfo.h> and nl_langinfo(CODESET). */
#cmakedefine HAVE_LANGINFO_CODESET @HAVE_LANGINFO_CODESET@

/* Define if you have the mbrtowc() function. */
#cmakedefine HAVE_MBRTOWC @HAVE_MBRTOWC@

/* Define to 1 if you have the setlocale() function. */
#cmakedefine HAVE_SETLOCALE @HAVE_SETLOCALE@

/* Define to 1 if you have the <stddef.h> header file. */
#cmakedefine HAVE_STDDEF_H @HAVE_STDDEF_H@

/* Define to 1 if you have the <stdlib.h> header file. */
#cmakedefine HAVE_STDLIB_H @HAVE_STDLIB_H@

/* Define to 1 if you have the <string.h> header file. */
#cmakedefine HAVE_STRING_H @HAVE_STRING_H@

/* Define to 1 or 0, depending whether the compiler supports simple visibility
   declarations. */
#cmakedefine HAVE_VISIBILITY @HAVE_VISIBILITY@

/* Define if you have the wcrtomb() function. */
#cmakedefine HAVE_WCRTOMB @HAVE_WCRTOMB@

/* Define to 1 if O_NOFOLLOW works. */
#cmakedefine HAVE_WORKING_O_NOFOLLOW @HAVE_WORKING_O_NOFOLLOW@

/* Define if the machine's byte ordering is little endian. */
#cmakedefine WORDS_LITTLEENDIAN @WORDS_LITTLEENDIAN@

/* Define to the value of ${prefix}, as a string. */
#cmakedefine INSTALLPREFIX @INSTALLPREFIX@

/* Define as good substitute value for EILSEQ. */
#cmakedefine EILSEQ @EILSEQ@

