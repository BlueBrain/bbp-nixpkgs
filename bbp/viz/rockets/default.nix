{ stdenv
, config
, fetchgit
, libwebsockets
, boost
, cmake
}:

stdenv.mkDerivation rec {
  name = "rockets-${version}";
  version = "0.1.0-dev201806";

  buildInputs = [ stdenv boost cmake libwebsockets ];

  src = fetchgit {
    url  = "https://github.com/BlueBrain/Rockets.git";
    rev = "616aee16abad4b749725664c6cad5ff5cd9633b7";
    sha256 = "1c0cx933xv4w47sggg34zg0ng2jq3nkqnr24sq6q50gilpg5czp1";
  };

  enableParallelBuilding = true;
}
