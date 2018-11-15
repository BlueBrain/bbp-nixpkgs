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
    rev = "40010260e58e542aebbd85bd2921d5c6a69cacb9";
    sha256 = "10maiwq4zh75prbavx756vq7sap5myj3fn1jdb6qsc37pwim3bsl";
  };

  enableParallelBuilding = true;
}
