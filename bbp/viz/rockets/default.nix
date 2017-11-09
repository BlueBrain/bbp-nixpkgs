{ stdenv
, config
, fetchgitPrivate
, libwebsockets
, boost
, cmake
}:

stdenv.mkDerivation rec {
  name = "rockets-${version}";
  version = "0.1.0-dev201710";

  buildInputs = [ stdenv boost cmake libwebsockets ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/viz/Rockets";
    rev = "89d020f80e67d9b63f4ddfd5e7f4c73797fa6b6c";
    sha256 = "1w6whcp758j9axfcjss65fbzs9wll42bh7f3xb7fysdijzmmx565";
  };

  enableParallelBuilding = true;
}
