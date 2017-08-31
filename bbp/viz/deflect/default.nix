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
  version = "0.13.0-dev201708";

  buildInputs = [ stdenv cmake boost freeglut mesa libjpeg_turbo libXi libXmu qt.base ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Deflect";
    rev = "6e260aa93609ed38220cf8283b03988cfe463c2b";
    sha256 = "0vy8wia7ar5w03g37g90wl95qkhha91rdcah2lz4hcawi8hz5b5g";
  };
  
  enableParallelBuilding = true;

  cmakeFlags = [ 
    "-DCOMMON_DISABLE_WERROR=TRUE"
  ];
  
}



