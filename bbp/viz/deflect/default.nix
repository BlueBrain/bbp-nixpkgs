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
  version = "0.13.0-2017.06";

  buildInputs = [ stdenv cmake boost freeglut mesa libjpeg_turbo libXi libXmu qt ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Deflect";
    rev = "5875621";
    sha256 = "13krgg3ggywbmhxkcvgm87ydwwwfq0dgjhjfbsnlvl83ihcrjxbd";
  };
  
  enableParallelBuilding = true;

  
}



