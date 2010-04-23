{ fetchurl, stdenv, useQt4 ? false, qt4 ? null
, useGlib ? true, glib ? null, gtk ? null
, useLibxml ? true, libxml2 ? null
, cairo, freetype, fontconfig, libjpeg, libpng
, pkgconfig, cmake}:

assert useQt4 -> (qt4 != null);
assert useGlib -> (glib != null && gtk != null);
assert useLibxml -> (libxml2 != null);

stdenv.mkDerivation rec {
  name = "poppler-0.12.4";

  src = fetchurl {
    url = "http://poppler.freedesktop.org/${name}.tar.gz";
    sha256 = "0yl55410xbgwlpbbjg9v9909mlwmzb54pdl25zlhkjscpma2myia";
  };

  buildInputs = [pkgconfig freetype fontconfig libjpeg libpng cmake]
    ++ stdenv.lib.optional useGlib [glib gtk cairo]
    ++ stdenv.lib.optional useLibxml libxml2
    ++ stdenv.lib.optional useQt4 qt4;

  configureFlags = " -DENABLE_XPDF_HEADERS=ON -DUSE_EXCEPTIONS=ON "
    + (if useLibxml then " -DENABLE_ABIWORD=ON " else " -DENABLE_ABIWORD=OFF ")
    + (if useGlib then " -DWITH_GLIB=ON -DBUILD_GTK_TESTS=ON " else " -DWITH_GLIB=OFF ")
    + (if useQt4 then " -DWITH_Qt4=ON -DBUILD_QT4_TESTS=ON " else " -DWITH_Qt4=OFF ");

  patches = [ ./GDir-const.patch ];

  # XXX: The Poppler/Qt4 test suite refers to non-existent PDF files
  # such as `../../../test/unittestcases/UseNone.pdf'.
  doCheck = !useQt4;
  checkTarget = "test";

  meta = {
    homepage = http://poppler.freedesktop.org/;
    description = "Poppler, a PDF rendering library";

    longDescription = ''
      Poppler is a PDF rendering library based on the xpdf-3.0 code base.
    '';

    license = "GPLv2";
  };
}
