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
    rev = "038e13946cdd5b35a43c31b18a7cd98d7d01921f";
    sha256 = "1m78mass3j3dl9apprak65llyabxjzdc8w47m1axf80k8v1bi3hp";
  };
  
  enableParallelBuilding = true;

}



