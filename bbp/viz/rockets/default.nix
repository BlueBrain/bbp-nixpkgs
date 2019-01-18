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
    rev = "f2b7d3e4eab89691a3c6a812f7374cf5925227d7";
    sha256 = "0ac7hgl366j4nwqsxcc8ygisyya8frl14isp8x31qdh4crzb7lzv";
  };

  enableParallelBuilding = true;
}
