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
    rev = "78773442eb89a8b6bd65b2aad42a83135e608021";
    sha256 = "0ipym5v69iivmrbikja65gzhrd4hqspc6q21vzj8g0j4cbaa70fi";
  };

  enableParallelBuilding = true;
}
