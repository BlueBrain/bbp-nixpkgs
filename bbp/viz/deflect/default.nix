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
  version = "0.14.0-dev201709";

  buildInputs = [ stdenv cmake boost freeglut mesa libjpeg_turbo libXi libXmu qt.base ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Deflect";
    rev = "ee41aa403bfab6a38108296c03f8e1f8bfd90151";
    sha256 = "12snvy2ngsi69f26g7bcxpd89ik0wl4d97apik50p4ba19c4kn5c";
  };
  
  enableParallelBuilding = true;

  cmakeFlags = [ 
    "-DCOMMON_DISABLE_WERROR=TRUE"
  ];
  
}



