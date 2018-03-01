{ stdenv
, config
, fetchgit
, libwebsockets
, boost
, cmake
}:

stdenv.mkDerivation rec {
  name = "rockets-${version}";
  version = "0.1.0-dev201802";

  buildInputs = [ stdenv boost cmake libwebsockets ];

  src = fetchgit {
    url  = "https://github.com/BlueBrain/Rockets.git";
    rev = "b67cfad8c5bf7f10a64b27996022b4fc19a9cfc9";
    sha256 = "0lrm6wjxrp48snhr64qhsmq3jkdp0qp50d4qywmgscsfvd2cnljf";
  };

  enableParallelBuilding = true;
}
