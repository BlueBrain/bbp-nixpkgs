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
    rev = "27a2bc811dee8d4cb7eef98a00a4a8443db9ad83";
    sha256 = "150bac7fsapimqcsyi48dx2xvkzncgndz58gshqv7m7hb0pak2s8";
  };

  enableParallelBuilding = true;
}
