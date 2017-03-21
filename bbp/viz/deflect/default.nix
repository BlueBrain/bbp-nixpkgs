{ stdenv
, fetchgitExternal
, cmake
, boost
, freeglut
, libXi
, libXmu 
, mesa
, libjpeg_turbo
, qt
, servus
}:

stdenv.mkDerivation rec {
  name = "deflect-${version}";
  version = "0.11.1-2016.10";

  buildInputs = [ stdenv boost freeglut mesa libjpeg_turbo libXi libXmu qt servus ];
  nativeBuildInputs = [ cmake ];


  src = fetchgitExternal {
    url = "https://github.com/BlueBrain/Deflect";
    rev = "ce15eaa0a32acd480e2a27ca632b67b07a46956d";
    sha256 = "1sgwhhyjphbk37h7i6798cl7fd2i6yfjhajbr6l6v7kmjnwdvh1m";
  };
  
  enableParallelBuilding = true;

  
}



