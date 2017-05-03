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
  version = "0.12.1-2017.04";

  buildInputs = [ stdenv cmake boost freeglut mesa libjpeg_turbo libXi libXmu qt servus ];

  src = fetchgitExternal {
    url = "https://github.com/rdumusc/Deflect";
    rev = "bc258e8f6711b520f837ab525f895c292313cb2f";
    sha256 = "06f5bn39bpkvnf2g9zfd7c7s000s0cql87y1v3q7cjx99hmk2agm";
  };
  
  enableParallelBuilding = true;

  
}



