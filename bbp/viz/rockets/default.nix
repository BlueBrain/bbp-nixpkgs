{ stdenv
, config
, fetchgit
, libwebsockets
, boost
, cmake
}:

stdenv.mkDerivation rec {
  name = "rockets-${version}";
  version = "0.1.0-dev201712";

  buildInputs = [ stdenv boost cmake libwebsockets ];

  src = fetchgit {
    url  = "https://github.com/BlueBrain/Rockets.git";
    rev = "0b6035fc97b46c7da7f2992d4d1d628fd92dafd4";
    sha256 = "03j68y2q5d6xmipqgx0fssprhnkc5f8pq72j5asic0zbcv19jhvk";
  };

  enableParallelBuilding = true;
}
