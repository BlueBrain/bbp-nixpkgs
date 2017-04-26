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
    url = "https://github.com/rdumusc/Deflect";
    rev = "ac9f9439e04c07f849dba88e24d18311614f6e8e";
    sha256 = "152kyw4jid5h1lhrf2cxbcld41ir0zjd5pj1yw2pk8fy5i4mvnsq";
  };
  
  enableParallelBuilding = true;

  
}



