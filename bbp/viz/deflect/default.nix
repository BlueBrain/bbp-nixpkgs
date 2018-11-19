{ stdenv
, fetchgit
, cmake
, boost
, freeglut
, libXi
, libXmu
, mesa
, libjpeg_turbo
, qt
}:

stdenv.mkDerivation rec {
  name = "deflect-${version}";
  version = "latest";

  buildInputs = [ stdenv cmake boost freeglut mesa libjpeg_turbo libXi libXmu qt.qtbase ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Deflect";
    rev = "ce0b490c7f2dbc3d5e24db87e869fff64ba7a392";
    sha256 = "1wi2zdqy2x35crma86jwxjqysdy4gcqkvprp75cyl8bg2qsa1ra0";
  };
  
  enableParallelBuilding = true;

}



