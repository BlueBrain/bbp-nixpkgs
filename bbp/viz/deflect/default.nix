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
    rev = "128e81529b3931df94b6059658da7d01db025417";
    sha256 = "05wn4axvrcdq03kwq3lhqhmpyrbwd2kwi1g6hrm4qyn4q8wjck3k";
  };
  
  enableParallelBuilding = true;

}



