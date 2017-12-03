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
  version = "0.14.0";

  buildInputs = [ stdenv cmake boost freeglut mesa libjpeg_turbo libXi libXmu qt.qtbase ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Deflect";
    rev = "cc4c7329c173673811d4b75e0770310d7c5d268d";
    sha256 = "0lnpq0r3358jq1far6wcfqpj9hpgzqgh00nd4nbkv5y0qqlihmv4";
  };
  
  enableParallelBuilding = true;

  cmakeFlags = [ 
    "-DCOMMON_DISABLE_WERROR=TRUE"
  ];
  
}



