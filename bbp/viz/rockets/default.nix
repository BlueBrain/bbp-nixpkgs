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
    rev = "b16497ca5d85e7151532866433b328d2bb2cb1e2";
    sha256 = "1m21d4dxacfx348hw2za1lacyxcf4fas8hjgyg8maz50swlmzf2p";
  };

  enableParallelBuilding = true;
}
