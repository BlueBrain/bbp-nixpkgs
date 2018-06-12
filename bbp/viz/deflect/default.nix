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
  version = "0.14.1";

  buildInputs = [ stdenv cmake boost freeglut mesa libjpeg_turbo libXi libXmu qt.qtbase ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Deflect";
    rev = "574bc3d3c5ba4f60297fe3c4f167992582c4773a";
    sha256 = "1pnb24fv710f1a0z78w6594gbyxm8gdpywmwb3nr0sj6hw8a2wb5";
  };
  
  enableParallelBuilding = true;

  cmakeFlags = [ 
    "-DCOMMON_DISABLE_WERROR=TRUE"
  ];
  
}



