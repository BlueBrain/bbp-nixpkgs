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
    rev = "cb66acbac2680dac5adfd65e067a3a2701fca342";
    sha256 = "01lz6dsi8yw40cp7cfpyc7g37lkbyh2n5gl7f4xrnm04h3r757z6";
  };

  enableParallelBuilding = true;
}
