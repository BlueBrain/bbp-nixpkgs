{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, doxygen, unzip
, freetype, libjpeg, jasper, libxml2, zlib, gdal, curl, libX11
, cairo, poppler, librsvg, libpng, libtiff, libXrandr
, xineLib, boost
, withApps ? false
, withSDL ? false, SDL
, withQt4 ? false, qt4
}:

stdenv.mkDerivation rec {
  name = "openscenegraph-${version}";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "openscenegraph";
    repo = "OpenSceneGraph";
    rev = "OpenSceneGraph-${version}";
    sha256 = "07pwap7dgiy3incc0im7bydkvwg8qdy522v1l4xi07s24d6vikw2";
  };

  nativeBuildInputs = [ pkgconfig cmake doxygen unzip ];

  buildInputs = [
    freetype libjpeg jasper libxml2 zlib gdal curl libX11
    cairo poppler librsvg libpng libtiff libXrandr boost
    xineLib
  ] ++ lib.optional withSDL SDL
    ++ lib.optional withQt4 qt4;

  enableParallelBuilding = true;

  cmakeFlags = lib.optional (!withApps) "-DBUILD_OSG_APPLICATIONS=OFF";

  meta = with stdenv.lib; {
    description = "A 3D graphics toolkit";
    homepage = http://www.openscenegraph.org/;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = "OpenSceneGraph Public License - free LGPL-based license";
  };
}



