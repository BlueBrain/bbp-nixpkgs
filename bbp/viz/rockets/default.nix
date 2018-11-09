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
    rev = "6202e9b9c32bd496dc2181ffa3b7a01d717b1931";
    sha256 = "0b3nphc6najc13psqkygyp6c1xf9vmr2hnp0phvi3h2d7wss34wk";
  };

  enableParallelBuilding = true;
}
