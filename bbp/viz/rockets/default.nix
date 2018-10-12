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
    rev = "13ec8c4b932d4d19f1ea67d23ae439ebab54e790";
    sha256 = "0lycn31y4cn0pfyawhm0cfnaxdvdmpn323r1dmfkg2q3h2wzz0zg";
  };

  enableParallelBuilding = true;
}
