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
  version = "0.14.0-201710";

  buildInputs = [ stdenv cmake boost freeglut mesa libjpeg_turbo libXi libXmu qt.base ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Deflect";
    rev = "de281e990716b1733f3b40a1eacdae81797bcce9";
    sha256 = "0na4bwp33agxyv73c9vw3ridb78j0mq82znrkah4cpr8h5vbbyx8";
  };
  
  enableParallelBuilding = true;

  cmakeFlags = [ 
    "-DCOMMON_DISABLE_WERROR=TRUE"
  ];
  
}



