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
    rev = "de6abb9238dbcbc65e5fdbf936bc856e3e29d6ae";
    sha256 = "1y2mdisvi5gawv9p46xas38n1wlrr8qpmvf3ik3riqgwv84i4ky0";
  };

  enableParallelBuilding = true;
}
