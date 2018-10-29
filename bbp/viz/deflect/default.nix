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
    rev = "75c562fa12cdda21b466795fa9395397421ae69d";
    sha256 = "1b9ywssi2gpbg2d1y0nzqysilwzln7hjfy0jhpm0msgamykf5xi3";
  };
  
  enableParallelBuilding = true;

}



