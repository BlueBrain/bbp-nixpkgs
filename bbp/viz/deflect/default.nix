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
    rev = "761f7d0b2a9b32e7bd403380ced2a31a99731056";
    sha256 = "0v057fiydxk3lgn76g120fyg4bwmi92qqxal7lybjj9zrxbpbjg7";
  };
  
  enableParallelBuilding = true;

}



