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
    rev = "cea15b2735809b56fa070250a03a9a0426db3b0c";
    sha256 = "1kl1bn0zcifr9k7r0rfkvr7p1q0maqp9zbcvl29xy9lgjmcv08lc";
  };

  enableParallelBuilding = true;
}
