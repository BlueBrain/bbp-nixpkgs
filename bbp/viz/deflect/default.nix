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
    rev = "427458e78b013d8f409325f10dd8222088eda160";
    sha256 = "07xk4jhyr6v9sgai7nyyxmhw2mrp79s5g0bvcjn0as7cbrcfphzi";
  };
  
  enableParallelBuilding = true;

}



