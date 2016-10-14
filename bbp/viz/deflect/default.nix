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
    rev = "fd77ea4eaba52ad9896a739bc64afc0e60b24fd9";
    sha256 = "0ps85rq9qb5h83qy4l0xxj0brm5frh30mq70lvfwh61dji3llnjd";
  };
  
  enableParallelBuilding = true;

  
}



