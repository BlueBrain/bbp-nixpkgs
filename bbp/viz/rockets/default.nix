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
    rev = "dbe625bd1d62426fdd18f676a8402a5c8ed354d0";
    sha256 = "1q7dmyk41jmckcn2paa6na844sbyfw3gx1yqlavfhd1paxa6fhjk";
  };

  enableParallelBuilding = true;
}
