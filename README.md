This project aims to provide a "one-click installation for DCMTK"

User can use the CMake to create the external supported libraries for Windows and Linux uesed by DCMTK, i.e., libxml, libpng, libtiff, zlib, openssl, iconv. However, the DCMTK's official release is only the source code of DCMTK. 

If you want to use the DCMTK with those supported libraries, you should download the pre-complied package for Windows created by DCMTK team that can be downloaded from:

Pre-compiled libraries for Windows (32 bit) with "MT" option
ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk360/support/dcmtk-3.6.0-win32-i386-support_MT.zip

Pre-compiled libraries for Windows (32 bit) with "MD" option
ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk360/support/dcmtk-3.6.0-win32-i386-support_MD.zip

The version of those libraries wasn't updated to the latest timely, because it will take much time to build them. Also, the versions of each libraries are quite old i.e zlib 1.2.5, libtiff 3.9.4, libpng 1.4.3, libxml2 2.7.7 with libiconv 1.13.1 and OpenSSL 1.0.0c

This project provides the CMake script to compile the DCMTK and those libraries automatically. User can download the latest libraries and compile with the snapshot of DCMTK. 

User can update the latest version of third-party libraries and rebuild them with DCMTK to create such as DLL, static, dynamic in both Windows and Linux environment.
