{ stdenv
, config
, fetchgit
, libwebsockets
, boost
, cmake
}:

stdenv.mkDerivation rec {
  name = "rockets-${version}";
  version = "latest";

  buildInputs = [ stdenv boost cmake libwebsockets ];

  src = fetchgit {
    url  = "https://github.com/BlueBrain/Rockets.git";
    rev = "8100fefa19c7e8339b0549e3b39ea25c3f83a597";
    sha256 = "0jikbvvgfrm8kyizr6wnnmi6073i6k1vh6n20k5i50idr23d251p";
  };

  enableParallelBuilding = true;
}
