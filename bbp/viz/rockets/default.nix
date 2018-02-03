{ stdenv
, config
, fetchgit
, libwebsockets
, boost
, cmake
}:

stdenv.mkDerivation rec {
  name = "rockets-${version}";
  version = "0.1.0-dev201801";

  buildInputs = [ stdenv boost cmake libwebsockets ];

  src = fetchgit {
    url  = "https://github.com/BlueBrain/Rockets.git";
    rev = "5d9143c41a143aaec015464a4af27ef52e5124bc";
    sha256 = "0lrm6wjxrp48snhr64qhsmq3jkdp0qp50d4qywmgscsfvd2cnljf";
  };

  enableParallelBuilding = true;
}
