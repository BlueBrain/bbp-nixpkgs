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
    rev = "c9a487bed99e2df2740aee493e3dfdfb069dff79";
    sha256 = "0nw73c3n8xvpb3hh9y92xrsld5bx6yha3p9by99qsrns1cfsdc1a";
  };

  enableParallelBuilding = true;
}
